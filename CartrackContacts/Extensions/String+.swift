//
//  String+.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

extension String {
    var utf8: UnsafePointer<Int8>? {
        (self as NSString).utf8String
    }
}
