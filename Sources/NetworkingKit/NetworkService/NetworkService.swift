import Foundation
import NetworkLogger

protocol NetworkServiceProtocol {
    typealias ResultValue = (Result<Data?, NetworkError>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class NetworkService {
    
    // MARK: - Private Properties
    
    private let networkRequestPerformer: NetworkRequestPerformerProtocol
    private let logger: NetworkLoggerProtocol
    
    // MARK: - Lifecycle
    
    init(networkRequestPerformer: NetworkRequestPerformerProtocol, logger: NetworkLoggerProtocol) {
        self.networkRequestPerformer = networkRequestPerformer
        self.logger = logger
    }
    
    public convenience init() {
        let networkRequestPerformer = NetworkRequestPerformer()
        let networkLogger = NetworkLogger()
        self.init(networkRequestPerformer: networkRequestPerformer, logger: networkLogger)
    }
}

// MARK: - NetworkServiceProtocol

extension NetworkService: NetworkServiceProtocol {
    
    @discardableResult
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {

        let task = self.networkRequestPerformer.request(request: request) { data, response, error in
            
            if let response = response as? HTTPURLResponse {
                let networkResponse = NetworkResponse(urlResponse: response, requestName: .unknown, data: data)
                self.logger.log(networkResponse)
            }
            
            if let error = error {
                var errorToBeReturned: NetworkError
                
                if let response = response as? HTTPURLResponse {
                    errorToBeReturned = .error(statusCode: response.statusCode)
                } else {
                    errorToBeReturned = .generic(error)
                }
                
                completion (.failure(errorToBeReturned))
            } else {
                completion(.success(data))
            }
        }
        
        let loggableRequest = NetworkRequest(urlRequest: request, requestName: .getMovieGenres)
        self.logger.log(loggableRequest)
        
        return task
    }
}
