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
    func createUserTable() throws {
        try createTable(model: User.self)
    }
    
    func insert(user: User) throws {
        let queryString = "INSERT INTO user (id, username, digest, country) VALUES (NULL, ?, ?, ?);"
        let statementPointer = try prepareStatement(query: queryString)
        defer { sqlite3_finalize(statementPointer) }
        guard
            sqlite3_bind_text(statementPointer, 1, user.username.utf8, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statementPointer, 2, user.digest.utf8, -1, nil)   == SQLITE_OK &&
            sqlite3_bind_text(statementPointer, 3, user.country.utf8, -1, nil)  == SQLITE_OK else {
            throw SQLite.Error.bind(message: recentErrorMessage)
        }
        guard sqlite3_step(statementPointer) == SQLITE_DONE else {
            throw SQLite.Error.step(message: recentErrorMessage)
        }
    }
    
    func getUser(username: String) -> User? {
        let queryString = "SELECT * FROM user WHERE username = ?;"
        guard let statementPointer = try? prepareStatement(query: queryString) else { return nil }
        
        defer { sqlite3_finalize(statementPointer) }
        
        guard sqlite3_bind_text(statementPointer, 1, username.utf8, -1, nil) == SQLITE_OK else { return nil }
        guard sqlite3_step(statementPointer) == SQLITE_ROW else { return nil }
        
        let id = sqlite3_column_int(statementPointer, 0)
        guard
            let queryResultUsername = sqlite3_column_text(statementPointer, 1),
            let queryResultDigest   = sqlite3_column_text(statementPointer, 2),
            let queryResultCountry  = sqlite3_column_text(statementPointer, 3) else {
            return nil
        }
        return User(
            id: Int(id),
            username: String(cString: queryResultUsername),
            digest: String(cString: queryResultDigest),
            country: String(cString: queryResultCountry)
        )
    }
}
