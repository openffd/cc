//
//  SQLite.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import SQLite3

enum SQLite {}

extension SQLite {
    enum Error: Swift.Error {
        case opening(message: String)
        
        static let genericMessage = "An unknown error occurred."
    }
}

extension OpaquePointer {
    var recentErrorMessage: String {
        guard let errorPointer = sqlite3_errmsg(self) else {
            return SQLite.Error.genericMessage
        }
        return String(cString: errorPointer)
    }
}
