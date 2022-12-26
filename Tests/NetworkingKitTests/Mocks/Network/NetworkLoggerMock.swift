//
//  DataTransferLoggerMock.swift
//  MovieAppTests
//
//  Created by Paul on 06/07/2022.
//

import Foundation
@testable import MovieApp

class NetworkLoggerMock: NetworkLoggerProtocol {
    
    // MARK: - log(_ request: URLRequest)
    
    var logRequestCallsCount: Int = 0
    
    // response
    var logRequestParameterReceived: NetworkRequest?
        
    var mostRecentRequestLog: Log?
    var requestLogs: [Log] = []
    
    func log(_ request: NetworkRequest) {
        self.logRequestCallsCount += 1
        self.logRequestParameterReceived = request

    }
    
    
    
    // MARK: - log(_ response: HTTPURLResponse)
    
    var logResponseCallsCount: Int = 0
    
    // response
    var logResponseParameterReceived: NetworkResponse?
    
    // withError
    var logRequestWithErrorParameterReceived: Error?
    
    var mostRecentResponseLog: Log?
    var responseLogs: [Log] = []

    func log(_ response: NetworkResponse) {
        self.log(response, withError: nil)
    }
    
    func log(_ response: NetworkResponse, withError error: Error?) {
        self.logResponseCallsCount += 1
        self.logResponseParameterReceived = response
    }
}
