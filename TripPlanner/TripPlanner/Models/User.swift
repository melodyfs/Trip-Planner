//
//  User.swift
//  TripPlanner
//
//  Created by Melody on 10/15/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import Foundation

struct User {
    
    var email: String
    var name: String
//    var password: String
    var destination: String
    var placeName: String
//    var longitude: Int
//    var latitude: Int
    var completion: Bool
    var startDate: String
    var endDate: String
    
    
    init(email: String, name: String, destination: String, placeName: String, completion: Bool, startDate: String, endDate: String) {
        self.email = email
        self.name = name
//        self.password = password
        self.destination = destination
        self.placeName = placeName
//        self.longitude = longitude
//        self.latitude = latitude
        self.completion = completion
        self.startDate = startDate
        self.endDate = endDate
    }
    
}

struct UserInfo: Decodable {
    let user: [User]
}

extension User: Decodable {
    
    enum Users: String, CodingKey {
        case email
        case name
//        case password
        case destination
        case placeName
        case completion
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    enum PlaceName: String, CodingKey {
        case placeName = "place_name"
//        case longitude
//        case latitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Users.self)
        let placeNameContainer = try container.nestedContainer (keyedBy: PlaceName.self, forKey: .placeName)
        
        let email: String = try container.decode(String.self, forKey: .email)
        let name: String = try container.decode(String.self, forKey: .name)
//        let password: String = try container.decode(String.self, forKey: .password)
        let destination: String = try container.decode(String.self, forKey: .destination)
        let completion: Bool = try container.decode(Bool.self, forKey: .completion)
        let startDate: String = try container.decode(String.self, forKey: .startDate)
        let endDate: String = try container.decode(String.self, forKey: .endDate)
        
        let placeName: String = try placeNameContainer.decode(String.self, forKey: .placeName)
//        let longitude: Int = try waypointContainer.decode(Int.self, forKey: .longitude)
//        let latitude: Int = try waypointContainer.decode(Int.self, forKey: .latitude)

        self.init(email: email, name: name, destination: destination, placeName: placeName, completion: completion, startDate: startDate, endDate: endDate)
        
    }
    
}










