//
//  Trip.swift
//  TripPlanner
//
//  Created by Melody on 10/16/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import Foundation

struct Trip: Codable {

    var completion: Bool
    var destination: String
    var start_date: String
    var end_date: String
}

