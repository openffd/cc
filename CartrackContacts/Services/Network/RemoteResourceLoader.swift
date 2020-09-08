//
//  NetworkServiceProvider.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/8/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

protocol NetworkServiceProvider {
    var dataFetcher: DataFetcher { get }
}

class RemoteResourceLoader<T: NetworkRequest>: NetworkServiceProvider {
    var dataFetcher: DataFetcher
    
    init(dataFetcher: DataFetcher = URLSession.shared) {
        self.dataFetcher = dataFetcher
    }
    
    func load<Resource>(
        networkRequest: T,
        resourceType: Resource.Type,
        completion: @escaping (Result<Resource, Error>) -> Void
    ) where Resource: Decodable {
        
        dataFetcher.fetch(from: networkRequest.request, deliverQueue: .main) { result in
            switch result {
            case .success(let data):
                do {
                    let decodable = try JSONDecoder().decode(resourceType, from: data)
                    completion(.success(decodable))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
