//
//  Trip.swift
//  TripPlanner
//
//  Created by Melody on 10/16/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import Foundation

//struct Trip: Decodable {
//
//    var destination: String
//    var placeName: String
//    var completion: Bool
//    var startDate: String
//    var endDate: String
//
//    init(destination: String, placeName: String, completion: Bool, startDate: String, endDate: String) {
//        self.destination = destination
//        self.placeName = placeName
//        self.completion = completion
//        self.startDate = startDate
//        self.endDate = endDate
//    }
//
//}
//
//extension Trip {
//
//    enum Trips: String, CodingKey {
//        case destination
//        case waypoints
//        case completion
//        case startDate = "start_date"
//        case endDate = "end_date"
//    }
//
//    enum Waypoints: String, CodingKey {
//        case placeName = "place_name"
//        //        case longitude
//        //        case latitude
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Trips.self)
//        let waypointContainer = try container.nestedContainer (keyedBy: Waypoints.self, forKey: .waypoints)
//
//        let destination: String = try container.decode(String.self, forKey: .destination)
//        let completion: Bool = try container.decode(Bool.self, forKey: .completion)
//        let startDate: String = try container.decode(String.self, forKey: .startDate)
//        let endDate: String = try container.decode(String.self, forKey: .endDate)
//
//        let placeName: String = try waypointContainer.decode(String.self, forKey: .placeName)
//        //        let longitude: Int = try waypointContainer.decode(Int.self, forKey: .longitude)
//        //        let latitude: Int = try waypointContainer.decode(Int.self, forKey: .latitude)
//
//        self.init(destination: destination, placeName: placeName, completion: completion, startDate: startDate, endDate: endDate)
//
//    }
//
//}

struct Trip: Decodable {
    
    var completion: Bool
    var destination: String
    var start_date: String
    var end_date: String
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
        print(tripsContainer.count)

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

