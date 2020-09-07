//
//  SQLiteDatabase.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import SQLite3

extension SQLite {
    static let sharedDatabaseURL = URL.documentDirectory.appendingPathComponent("Shared.sqlite")
    
    class Database {
        static let shared: Database = {
            let database: Database
            do {
                database = try Database.open(path: SQLite.sharedDatabaseURL.absoluteString)
                return database
            } catch {
                print(error.localizedDescription)
                return Database(databasePointer: nil)
            }
        }()
        
        private let databasePointer: DatabasePointer?
        
        private init(databasePointer: DatabasePointer? = nil) {
            self.databasePointer = databasePointer
        }
        
        deinit {
            guard let databasePointer = self.databasePointer else { return }
            sqlite3_close(databasePointer)
        }
        
        static func open(path: String) throws -> SQLite.Database {
            var pointer: OpaquePointer?
            guard sqlite3_open(path, &pointer) == SQLITE_OK else {
                defer { sqlite3_close(pointer) }
                
                if let _ = pointer {
                    throw SQLite.Error.opening(message: "")
                } else {
                    throw SQLite.Error.opening(message: SQLite.Error.genericMessage)
                }
            }
            return SQLite.Database(databasePointer: pointer)
        }
    }
}
