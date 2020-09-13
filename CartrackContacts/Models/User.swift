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

enum UsernameAvailability {
    case available, unavailable
    
    var message: String {
        switch self {
        case .unavailable:
            return "This username is already taken.\nPlease try another."
        default:
            return ""
        }
    }
}

protocol UserDatabase {
    func createUserTable() throws
    func insert(username: String, digest: String, country: String) throws -> User
    func getUser(username: String, digest: String) -> User?
    func checkUser(username: String) -> UsernameAvailability
}

extension User: SQLiteTableModel {
    static var tableCreationQuery: String {
        """
        CREATE TABLE IF NOT EXISTS user(
            id          INTEGER NOT NULL    PRIMARY KEY,
            username    TEXT    NOT NULL    UNIQUE,
            digest      TEXT    NOT NULL,
            country     TEXT    NOT NULL
        );
        """
    }
}
