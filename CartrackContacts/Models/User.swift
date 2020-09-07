//
//  User.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let username: String
    let digest: String
    let country: String
}

protocol UserDatabase {
    func createTable()
    func insertUser(user: User)
    func getUser(username: String) -> User?
}
