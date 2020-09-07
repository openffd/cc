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
        
    }
    
    func getUser(username: String) -> User? {
        nil
    }
}
