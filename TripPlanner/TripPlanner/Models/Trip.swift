//
//  Trip.swift
//  TripPlanner
//
//  Created by Melody on 10/16/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import Foundation

struct Trip: Decodable {
    
    var completion: Bool!
    var destination: String!
    var start_date: String!
    var end_date: String!
    var trips = [Trip]()
   
    init(completion: Bool, destination: String, start_date: String, end_date: String) {
        self.completion = completion
        self.destination = destination
        self.start_date = start_date
        self.end_date = end_date


    }
}

extension Trip {
    
    enum Trips: String, CodingKey {
        case trips
        
        enum Trip: String, CodingKey{
            case completion
            case destination
            case start_date
            case end_date
        }

    }
    
    
    init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: Trips.self)
        var tripsContainer = try container.nestedUnkeyedContainer(forKey: .trips)

        while !tripsContainer.isAtEnd {
            let container = try tripsContainer.nestedContainer(keyedBy: Trips.Trip.self)
            let completion = try container.decode(Bool.self, forKey: .completion)
            let destination = try container.decode(String.self, forKey: .destination)
            let startDate = try container.decode(String.self, forKey: .start_date)
            let endDate = try container.decode(String.self, forKey: .end_date)

            // initialize a listing object
            let trip = Trip(completion: completion, destination: destination, start_date: startDate, end_date: endDate)
            self.trips.append(trip)
        }
    }

}

