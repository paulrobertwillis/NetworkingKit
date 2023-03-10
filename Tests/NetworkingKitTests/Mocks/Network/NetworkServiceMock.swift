import Foundation
@testable import NetworkingKit

class NetworkServiceMock: NetworkServiceProtocol {
    
    // MARK: - request
    
    var requestCallsCount = 0
    var requestReturnValue: URLSessionTask? = URLSessionTask()
        
    // request parameter
    var requestReceivedRequest: URLRequest?
    
    // completion parameter
    var requestCompletionReturnValue: ResultValue = .success(nil)

    func request(request: URLRequest, completion: CompletionHandler) -> URLSessionTask? {
        self.requestCallsCount += 1
        
        self.requestReceivedRequest = request
        
        completion(requestCompletionReturnValue)
        
        return requestReturnValue
    }
}
