@testable import NetworkingKit
import NetworkLogger

class NetworkLoggerMock: NetworkLoggerProtocol {
    
    // MARK: - log(_ request: URLRequest)
    
    var logRequestCallsCount: Int = 0
    
    // response
    var logRequestParameterReceived: LoggableRequest?
    
    func log(_ request: LoggableRequest) {
        self.logRequestCallsCount += 1
        self.logRequestParameterReceived = request

    }
        
    // MARK: - log(_ response: HTTPURLResponse)
    
    var logResponseCallsCount: Int = 0
    
    // response
    var logResponseParameterReceived: LoggableResponse?
    
    // withError
    var logRequestWithErrorParameterReceived: Error?
    
    func log(_ response: LoggableResponse) {
        self.log(response, withError: nil)
    }
    
    func log(_ response: LoggableResponse, withError error: Error?) {
        self.logResponseCallsCount += 1
        self.logResponseParameterReceived = response
    }
}
