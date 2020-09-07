//
//  SHA256Digest+.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation
import CryptoKit

extension SHA256.Digest {
    var string: String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}
