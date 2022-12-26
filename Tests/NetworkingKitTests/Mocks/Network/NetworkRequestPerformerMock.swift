import Foundation
@testable import NetworkingKit

class NetworkRequestPerformerMock: NetworkRequestPerformerProtocol {
    
    let data: Data?
    let response: HTTPURLResponse?
    let error: Error?
    
    var requestCallsCount: Int = 0
    
    init(data: Data?, response: HTTPURLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        self.requestCallsCount += 1
        
        completion(data, response, error)
        return URLSessionDataTask()
    }
}
