import Foundation

enum NetworkError: Error {
    case error(statusCode: Int)
    case generic(Error)
    case someError
}
