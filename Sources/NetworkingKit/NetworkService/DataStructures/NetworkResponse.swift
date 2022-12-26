import Foundation
import NetworkLogger

struct NetworkResponse: LoggableResponse {
    let urlResponse: HTTPURLResponse
    var requestName: String
    let data: Data?
    
    init(urlResponse: HTTPURLResponse,
         requestName: RequestName,
         data: Data? = nil) {
        self.urlResponse = urlResponse
        self.requestName = requestName.rawValue
        self.data = data
    }
}
