//
//  DataFetcher.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

protocol DataFetcher: AnyObject {
    func fetch(from request: URLRequest, deliverQueue: DispatchQueue, completion: @escaping (Result<Data, Error>) -> Void)
}

typealias DataRequestCompletion = (Result<Data, Error>) -> Void

extension URLSession: DataFetcher {
    private func dataTask(with request: URLRequest, completion: @escaping DataRequestCompletion) -> URLSessionDataTask {
        dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(data ?? Data()))
        }
    }
    
    func fetch(from request: URLRequest, deliverQueue: DispatchQueue = .main, completion: @escaping DataRequestCompletion) {
        dataTask(with: request) { result in
            switch result {
            case .success(let data):
                deliverQueue.async { completion(.success(data)) }
            case .failure(let error):
                deliverQueue.async { completion(.failure(error)) }
            }
        }.resume()
    }
}

fileprivate extension URLSessionDataTask { typealias Priority = Float }
fileprivate extension URLSessionDataTask.Priority {
    static let highest: URLSessionDataTask.Priority = 1.0
}

fileprivate extension HTTPURLResponse {
    var isStatusOK: Bool { statusCode == 200 }
}
