//
//  ContactsAPI.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

enum ContactsRequest {
    case contacts
}

extension ContactsRequest: NetworkRequest {
    var method: NetworkRequestMethod {
        switch self {
        case .contacts:
            return .GET
        }
    }
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        "jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .contacts:
            return "/users"
        }
    }
    
    var params: [String : String] {
        switch self {
        case .contacts:
            return [:]
        }
    }
}
