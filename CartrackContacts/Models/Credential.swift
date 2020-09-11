//
//  Credential.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/10/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

protocol LoginCredential {
    var username: String { get }
    var password: String { get }
}

struct Credential: LoginCredential {
    let username: String
    let password: String
}
