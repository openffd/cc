//
//  Company.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

extension Contact {
    struct Company: Codable {
        let name: String
        let catchPhrase: String
        let business: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case catchPhrase
            case business = "bs"
        }
    }
}
