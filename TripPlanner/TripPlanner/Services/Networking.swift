//
//  Networking.swift
//  TripPlanner
//
//  Created by Melody on 10/15/17.
//  Copyright © 2017 Melody Yang. All rights reserved.
//

import Foundation

struct BasicAuth {
    static func generateBasicAuthHeader(username: String, password: String) -> String {
        let loginString = String(format: "%@:%@", username, password)
        let loginData: Data = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString(options: .init(rawValue: 0))
        let authHeaderString = "Basic \(base64LoginString)"
        
        return authHeaderString
    }
}


enum Route {
    case createUser
//    (email: String, password: String)
    case getUser
    case createTrip
    
    func path() -> String {
        switch self {
        case .createUser: fallthrough
        case .getUser:
            return "user/"
        case .createTrip:
            return "user/trips/"
        }
    }
    
    func headers() -> [String: String] {
        switch self {
        case .createUser:
            return [:]
        default:
            let headers = ["Content-Type": "application/json",
                           "Accept": "application/json",
                           "Authorization": String(describing: UserDefaults.standard.value(forKey: "BasicAuth")!)]
            
            return headers
        }
        
    }
    
    func urlParams() -> [String: String] {
        switch self {
        case .createUser:
            return [:]
        default:
            let urlParams = ["email": String(describing: UserDefaults.standard.value(forKey: "email")!)]
            return urlParams
        }
    }
//    data: Encodable?
    
    func body(data: Encodable?) -> Data? {
        switch self {
//            let .createUser(email, password)
        case .createUser:
            let body = ["email": "email",
                        "password": "password"]
//            let httpBody = try? JSONSerialization.data(withJSONObject: body)
//            return httpBody
            let encoder = JSONEncoder()
            guard let model = data as? User else {return nil}
            let result = try? encoder.encode(model)
            let jsonString = String(data: result!, encoding: .utf8)
            print(jsonString)

            return result
        case .createTrip:
            let encoder = JSONEncoder()
            guard let model = data as? NewTrip else {return nil}
            let result = try? encoder.encode(model)
            let jsonString = String(data: result!, encoding: .utf8)
            print(jsonString)
            
            return result
        default:
            let error = ["error": "incorrect method"]
            let jsonErr = try? JSONSerialization.data(withJSONObject: error)
            return jsonErr
        }
    }
    
    func method() -> String {
        switch self {
        case .createUser: fallthrough
        case .createTrip:
            return "POST"
        default:
            return "GET"
        }
    }

    
    
}



class Networking {
    
    static var shared = Networking()
    
    let session = URLSession.shared
    let baseURL = "http://127.0.0.1:5000/"
    
    func fetch(route: Route, data: Encodable?, completion: @escaping (Data) -> Void) {
        let fullURL = baseURL.appending(route.path())
        var url = URL(string: fullURL)!
        url = url.appendingQueryParameters(route.urlParams())
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = route.headers()
        request.httpBody = route.body(data: data)
        request.httpMethod = route.method()
        UserDefaults.standard.synchronize()
//        Route.createUser(email: (UserDefaults.standard.value(forKey: "email")) as! String, password: (UserDefaults.standard.value(forKey: "password")) as! String)
//
        session.dataTask(with: request) { (data, res, err) in
            if let data = data {
//                print("get to networking")
                completion(data)
            }
            else {
                print(err?.localizedDescription ?? "Error")
            }
            
        }.resume()
        
    }
    
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}









