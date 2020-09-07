//
//  ContactsAPI.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

protocol ContactsAPI {
    func getContacts() -> [Contact]?
}

