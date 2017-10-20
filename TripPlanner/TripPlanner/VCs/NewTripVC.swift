//
//  NewTripVC.swift
//  TripPlanner
//
//  Created by Melody on 10/19/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import UIKit

class NewTripVC: UIViewController {

    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!

    @IBAction func createTrip(_ sender: Any) {
        let trip = NewTrip(completion: false, destination: destinationTextField.text!, start_date: startDateTextField.text!, end_date: endDateTextField.text!)
        
        Networking.shared.fetch(route: .createTrip, data: trip) { (data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let trip = json else {
                return
            }
            
            print(trip)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
