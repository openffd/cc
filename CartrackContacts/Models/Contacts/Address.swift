//
//  Address.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

extension Contact {
    struct Address: Codable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let location: GeographicLocation
        
        var line1: String {
            "\(suite), \(street)"
        }
        
        var line2: String {
            "\(city), \(zipcode)"
        }
        
        enum CodingKeys: String, CodingKey {
            case street
            case suite
            case city
            case zipcode
            case location = "geo"
        }
    }
}

extension Contact.Address {
    struct GeographicLocation: Codable {
        let latitude: String
        let longitude: String
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lng"
        }
    }
}
