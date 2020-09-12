//
//  Contacts.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import UIKit

final class Contact: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
    
    var displayEmail: String {
        email.lowercased()
    }
    
    init(
        id: Int,
        name: String,
        username: String,
        email: String,
        address: Address,
        phone: String,
        website: String,
        company: Company
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
}

protocol Colored {
    var color: UIColor { get }
}

extension Contact: Colored {
    var color: UIColor {
        UIColor.systemColors[id % UIColor.systemColors.count]
    }
}

private extension UIColor {
    static let systemColors: [UIColor] = [
        .systemRed,
        .systemGreen,
        .systemBlue,
        .systemOrange,
        .systemYellow,
        .systemPurple,
        .systemTeal,
    ]
}
