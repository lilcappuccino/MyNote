//
//  NetworkUtils.swift
//  MyNotes
//
//  Created by dewill on 04/08/2019.
//  Copyright © 2019 dewill. All rights reserved.
//

import Foundation



class NetworkUtils {
   static let TAG = "NetworkUtils"
    
static func getBaseRequest(url: URL) -> URLRequest? {
    guard let token = NoteDefaults.token else { return nil }
        var request  = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func getCode() -> URLRequest? {
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")
        components?.queryItems = [URLQueryItem(name: "client_id", value: clientId)]
        
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    

}


let baseUrl = "https://api.github.com"
let postCode = "https://github.com/login/oauth/access_token"
let clientId = "32f8ad0623c345de0103"
let clientSecret = "73f1a168c4abf2ae0ffe242f9a095504e74a301f"
