@testable import NetworkingKit
import NetworkLogger

class NetworkLoggerMock: NetworkLoggerProtocol {
    
    // MARK: - log(_ request: URLRequest)
    
    var logRequestCallsCount: Int = 0
    
    // response
    var logRequestParameterReceived: NetworkLogger.LoggableRequest?
    
    func log(_ request: NetworkLogger.LoggableRequest) {
        self.logRequestCallsCount += 1
        self.logRequestParameterReceived = request

    }
        
    // MARK: - log(_ response: HTTPURLResponse)
    
    var logResponseCallsCount: Int = 0
    
    // response
    var logResponseParameterReceived: NetworkLogger.LoggableResponse?
    
    // withError
    var logRequestWithErrorParameterReceived: Error?
    
    func log(_ response: NetworkLogger.LoggableResponse) {
        self.log(response, withError: nil)
    }
    
    func log(_ response: NetworkLogger.LoggableResponse, withError error: Error?) {
        self.logResponseCallsCount += 1
        self.logResponseParameterReceived = response
    }
}
