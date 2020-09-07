//
//  SQLiteDatabase+User.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import SQLite3

extension SQLite.Database: UserDatabase {
    func createTable() throws {
        try createTable(model: User.self)
    }
    
    func insertUser(user: User) throws {
        let queryString = "INSERT INTO user (id, username, digest, country) VALUES (NULL, ?, ?, ?);"
        let statementPointer = try prepareStatement(query: queryString)
        defer { sqlite3_finalize(statementPointer) }
        guard
            sqlite3_bind_text(statementPointer, 1, user.username.utf8, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statementPointer, 2, user.digest.utf8, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statementPointer, 3, user.country.utf8, -1, nil) == SQLITE_OK else {
            throw SQLite.Error.bind(message: recentErrorMessage)
        }
        guard sqlite3_step(statementPointer) == SQLITE_DONE else {
            throw SQLite.Error.step(message: recentErrorMessage)
        }
    }
    
    func getUser(username: String) -> User? {
        nil
    }
}
