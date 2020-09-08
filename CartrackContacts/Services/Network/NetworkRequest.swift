//
//  NetworkService.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/8/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

enum NetworkRequestMethod: String {
    case GET
}

protocol NetworkRequest {
    var method: NetworkRequestMethod { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var params: [String: String] { get }
}

extension NetworkRequest {
    var request: URLRequest {
        guard let url = self.url else { fatalError("Unable to build the URL.") }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        request.httpMethod = method.rawValue
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.host = host
        components.scheme = scheme
        components.path = path
                
        switch method {
        case .GET:
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return components.url
    }
}
