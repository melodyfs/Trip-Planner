//
//  HomeVC.swift
//  TripPlanner
//
//  Created by Melody on 10/15/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    var basicAuth = ""
    
    @IBAction func loginButton(_ sender: Any) {
        
        UserDefaults.standard.set(emailTextField.text, forKey: "email")
        UserDefaults.standard.set(passwordTextField.text, forKey: "password")
        
        let username = UserDefaults.standard.value(forKey: "email")!
        let password = UserDefaults.standard.value(forKey: "password")!

        basicAuth = BasicAuth.generateBasicAuthHeader(username: username as! String, password: password as! String)
         UserDefaults.standard.set(basicAuth, forKey: "BasicAuth")
        
        DispatchQueue.main.async {
            self.basicAuth = BasicAuth.generateBasicAuthHeader(username: username as! String, password: password as! String)
            UserDefaults.standard.set(self.basicAuth, forKey: "BasicAuth")
            UserDefaults.standard.synchronize()
            Networking.shared.fetch(route: .getUser) { (data) in
                let trips = try? JSONDecoder().decode(Trip.self, from: data)
                print(trips)
                
                
            }
        }
       
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
        }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}





