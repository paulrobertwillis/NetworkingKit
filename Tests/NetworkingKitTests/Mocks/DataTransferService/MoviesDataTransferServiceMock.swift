//
//  MoviesDataTransferServiceMock.swift
//  MovieAppTests
//
//  Created by Paul on 03/09/2022.
//

import Foundation
@testable import NetworkingKit

class MoviesDataTransferServiceMock: DataTransferService<MoviesResponseDTO> {
    
    // MARK: - Lifecycle
    
    init() {
        super.init(networkService: NetworkServiceMock())
    }
    
    // MARK: - request(request, completion)
    
    var requestCallsCount = 0
    
    // request parameter
    var requestReceivedRequest: URLRequest?
    
    // completion parameter
    var requestCompletionReturnValue: ResultValue?
    var requestReceivedCompletion: CompletionHandler? = { _ in }

    override func request(_ request: URLRequest, decoder: ResponseDecoderProtocol, completion: @escaping (Result<GenericDecodable, DataTransferError>) -> Void) -> URLSessionTask? {
        self.requestCallsCount += 1
        
        self.requestReceivedRequest = request
        self.requestReceivedCompletion = completion
        
        if let requestCompletionReturnValue = requestCompletionReturnValue {
            completion(requestCompletionReturnValue)
        }

        return URLSessionTask()
    }

}
