//
//  User.swift
//  TripPlanner
//
//  Created by Melody on 10/15/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    var email: String
    var name: String
    var trips: [Trip]

    init(email: String, name: String, trips: [Trip]) {
        self.email = email
        self.name = name
        self.trips = trips

    }
    
}











