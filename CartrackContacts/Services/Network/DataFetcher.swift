//
//  DataFetcher.swift
//  CartrackContacts
//
//  Created by Feb De La Cruz on 9/7/20.
//  Copyright © 2020 Feb De La Cruz. All rights reserved.
//

import Foundation

protocol DataFetcher: AnyObject {
    func fetch<T>(from request: URLRequest, completion: @escaping (T?, NSError?) -> Void) where T: DataInstantiatable
}

extension URLSession: DataFetcher {
    func fetch<T>(from request: URLRequest, completion: @escaping (T?, NSError?) -> Void) where T: DataInstantiatable {
        let dataTask = self.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            guard response.isStatusOK else {
                return
            }
            
            guard data != nil else {
                return
            }
            
            do {
                guard let object: T = try data.flatMap(T.decoder) else { return }
                completion(object, nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.priority = .highest
        dataTask.resume()
    }
}

fileprivate extension URLSessionDataTask { typealias Priority = Float }
fileprivate extension URLSessionDataTask.Priority {
    static let highest: URLSessionDataTask.Priority = 1.0
}

fileprivate extension HTTPURLResponse {
    var isStatusOK: Bool { statusCode == 200 }
}
