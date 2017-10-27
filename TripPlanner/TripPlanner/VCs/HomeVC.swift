//
//  HomeVC.swift
//  TripPlanner
//
//  Created by Melody on 10/15/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

class HomeVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    var basicAuth = ""
    let keychain = KeychainSwift()
    
    @IBAction func signUpButton(_ sender: Any) {
        
        keychain.set(emailTextField.text!, forKey: "email")
        keychain.set(passwordTextField.text!, forKey: "password")
        
        let username = keychain.get("email")!
        let password = keychain.get("password")!
        
        basicAuth = BasicAuth.generateBasicAuthHeader(username: username , password: password)
        keychain.set(basicAuth, forKey: "BasicAuth")
        
        let user = User(email: "\(username)", password: "\(password)")
        
        
        Networking.shared.fetch(route: .createUser, data: user) { (data) in
            
            print("User created")
            
        }
        
        

        
        
    }
    @IBAction func loginButton(_ sender: Any) {
        
        keychain.set(emailTextField.text!, forKey: "email")
        keychain.set(passwordTextField.text!, forKey: "password")
        
        let username = keychain.get("email")!
        let password = keychain.get("password")!
        
        basicAuth = BasicAuth.generateBasicAuthHeader(username: username , password: password)
        keychain.set(basicAuth, forKey: "BasicAuth")
        
        DispatchQueue.main.async {
            Networking.shared.fetch(route: .getUser, data: nil) { (data) in
                let trips = try? JSONDecoder().decode(Trip.self, from: data)
                print(trips)
                
            }
        }
       
        
        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        <#code#>
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

        if launchedBefore {
//            performSegue(withIdentifier: "showTrips", sender: nil)
            let showResult = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tripsVC") as! TripsVC
            navigationController?.pushViewController(showResult, animated: true)
        } else {
            let showResult = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! HomeVC
            navigationController?.pushViewController(showResult, animated: true)
        }
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}





