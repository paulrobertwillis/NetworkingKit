//
//  DataTransferService.swift
//  MovieApp
//
//  Created by Paul on 30/06/2022.
//

import Foundation

public enum DataTransferError: Error {
    case parsingFailure(Error)
    case missingData
    case decodingFailure
}

public protocol DataTransferServiceProtocol {
    associatedtype GenericDecodable: Decodable
    
    typealias ResultValue = (Result<GenericDecodable, DataTransferError>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func request(_ request: URLRequest, decoder: ResponseDecoderProtocol, completion: @escaping CompletionHandler) -> URLSessionTask?
}

public class DataTransferService<GenericDecodable: Decodable>: DataTransferServiceProtocol {
    
    // MARK: - Private Properties
    
    private let networkService: NetworkServiceProtocol
    private let decoder: ResponseDecoderProtocol = JSONResponseDecoder()
    
    // MARK: - Lifecycle
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public convenience init() {
        let networkService = NetworkService()
        self.init(networkService: networkService)
    }
    
    // MARK: - API
        
    @discardableResult
    public func request(_ request: URLRequest, decoder: ResponseDecoderProtocol, completion: @escaping (Result<GenericDecodable, DataTransferError>) -> Void) -> URLSessionTask? {
        
        let dataSessionTask = self.networkService.request(request: request) { result in
            switch result {
            case .success(let data):
                let result: ResultValue = self.decode(data, decoder: decoder)
                completion(result)
            case .failure(let error):
                let resolvedError = self.resolve(error)
                completion(.failure(resolvedError))
            }
        }
                
        return dataSessionTask
    }
    
    // MARK: - Helpers
    
    // TODO: Consider how to migrate this decode function to the more appropriate ResponseDecoder object
    private func decode<T: Decodable>(_ data: Data?, decoder: ResponseDecoderProtocol) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.missingData) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(.parsingFailure(error))
        }
    }
    
    private func resolve(_ error: Error) -> DataTransferError {
        return DataTransferError.parsingFailure(error)
    }
}

// TODO: Extract DataTransferErrorResolver
