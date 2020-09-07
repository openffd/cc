//
//  DataDecodable.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

protocol DataInstantiatable: Decodable {
    static var decoder: (Data) throws -> Self? { get }
}

extension DataInstantiatable {
    static var decoder: (Data) throws -> Self? {
        return { data -> Self? in
            try JSONDecoder().decode(Self.self, from: data)
        }
    }
}
