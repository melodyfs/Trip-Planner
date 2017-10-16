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
    var password: String
    var destination: String
    var placeName: String
    var longitude: Double
    var latitude: Double
    var completion: Bool
    var startDate: String
    var endDate: String
    
    
    init(email: String, name: String, password: String, destination: String, placeName: String, longitude: Double, latitude: Double, completion: Bool, startDate: String, endDate: String) {
        self.email = email
        self.name = name
        self.password = password
        self.destination = destination
        self.placeName = placeName
        self.longitude = longitude
        self.latitude = latitude
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
        case password
        case destination
        case waypoints
        case completion
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    enum Waypoints: String, CodingKey {
        case placeName = "place_name"
        case longitude
        case latitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Users.self)
        let waypointContainer = try container.nestedContainer (keyedBy: Waypoints.self, forKey: .waypoints)
        
        let email: String = try container.decode(String.self, forKey: .email)
        let name: String = try container.decode(String.self, forKey: .name)
        let password: String = try container.decode(String.self, forKey: .password)
        let destination: String = try container.decode(String.self, forKey: .destination)
        let completion: Bool = try container.decode(Bool.self, forKey: .completion)
        let startDate: String = try container.decode(String.self, forKey: .startDate)
        let endDate: String = try container.decode(String.self, forKey: .endDate)
        
        let placeName: String = try waypointContainer.decode(String.self, forKey: .placeName)
        let longitude: Double = try waypointContainer.decode(Double.self, forKey: .longitude)
        let latitude: Double = try waypointContainer.decode(Double.self, forKey: .latitude)
        
        self.init(email: email, name: name, password: password, destination: destination, placeName: placeName, longitude: longitude, latitude: latitude, completion: completion, startDate: startDate, endDate: endDate)
        
    }
    
}










