//
//  NetworkRequestPerformer.swift
//  MovieApp
//
//  Created by Paul on 08/07/2022.
//

import Foundation

protocol NetworkRequestPerformerProtocol {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask
}

class NetworkRequestPerformer: NetworkRequestPerformerProtocol {
    // TODO: Replace URLRequest here with NetworkRequest?
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
    
    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        return URLSessionTask()
    }
}
