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
    func createTable() throws
    func insertUser(user: User) throws
    func getUser(username: String) -> User?
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
