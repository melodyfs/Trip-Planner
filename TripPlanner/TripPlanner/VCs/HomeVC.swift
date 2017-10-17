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
    
    var trips: [Trip] = []
    var basicAuth = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicAuth = BasicAuth.generateBasicAuthHeader(username: "newuser@email.com", password: "newuser")
        
        Networking.shared.fetch(route: .getUser) { (data) in
//            print(data)
            let trips = try? JSONDecoder().decode(Trip.self, from: data)
            print(trips)
            guard let trip = trips?.trips else { return }
//            self.trips = trip
            
           
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
