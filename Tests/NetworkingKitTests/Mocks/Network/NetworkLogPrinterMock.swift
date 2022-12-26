//
//  NetworkLogPrinterMock.swift
//  MovieAppTests
//
//  Created by Paul on 08/07/2022.
//

import Foundation
@testable import MovieApp

class NetworkLogPrinterMock: NetworkLogPrinterProtocol {
    var printedLog: String = ""
    
    // MARK: - printToDebugArea
    
    var recordLogCallCount = 0
    
    // log
    var recordLogParameterReceived: Log?
    
    func writeLog(_ log: Log) {
        self.recordLogCallCount += 1
        self.recordLogParameterReceived = log
    }
}
