//
//  DataDecodable.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

protocol DataDecodable: Decodable {
    static var decoder: (Data) -> Self? { get }
}

extension DataDecodable {
    static var decoder: (Data) -> Self? {
        return { data -> Self? in try? JSONDecoder().decode(Self.self, from: data) }
    }
}
