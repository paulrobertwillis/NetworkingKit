import Foundation
import NetworkLogger

struct NetworkRequest: LoggableRequest {
    let urlRequest: URLRequest
    var requestName: String
    
    init(urlRequest: URLRequest, requestName: RequestName) {
        self.urlRequest = urlRequest
        self.requestName = requestName.rawValue
    }
}
