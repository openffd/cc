//
//  URL+.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

extension URL {
    static let documentDirectory: URL = {
        let manager = FileManager.default
        return try! manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }()
}
