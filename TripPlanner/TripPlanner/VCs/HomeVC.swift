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
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Networking.shared.fetch(route: .getUser) { (data) in
            
            let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data)

            guard let user = userInfo?.user else { return }
            self.users = user
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
