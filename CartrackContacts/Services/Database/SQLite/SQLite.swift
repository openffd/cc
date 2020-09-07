//
//  SQLite.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import SQLite3

protocol SQLiteTableModel {
    static var tableCreationQuery: String { get }
}

enum SQLite {
    static let sharedDatabaseURL = URL.documentDirectory.appendingPathComponent("Shared.sqlite")
}

extension SQLite {
    typealias GenericPointer = OpaquePointer
    typealias DatabasePointer = OpaquePointer
    typealias StatementPointer = OpaquePointer
}

extension SQLite {
    enum Error: Swift.Error {
        case open(message: String)
        case prepare(message: String)
        case step(message: String)
        
        static let genericMessage = "An unknown error occurred."
    }
}

extension SQLite.GenericPointer {
    var recentErrorMessage: String {
        guard let errorPointer = sqlite3_errmsg(self) else {
            return SQLite.Error.genericMessage
        }
        return String(cString: errorPointer)
    }
}
