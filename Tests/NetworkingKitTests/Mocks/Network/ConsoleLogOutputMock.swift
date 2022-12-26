//
//  ConsoleLogOutputMock.swift
//  MovieAppTests
//
//  Created by Paul on 08/07/2022.
//

import Foundation
@testable import MovieApp

class ConsoleLogOutputMock: LogOutputProtocol {
    
    // MARK: - write(_ string: String)
    
    var writeCallCount = 0
    
    // string
    var writeStringParametersReceived: [String] = []
    
    func write(_ string: String) {
        self.writeCallCount += 1
        self.writeStringParametersReceived.append(string)
        
        print(string)
    }
}
