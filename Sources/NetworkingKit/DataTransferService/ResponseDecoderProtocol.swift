import Foundation

public protocol ResponseDecoderProtocol {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

// MARK: - JSONResponseDecoder

public class JSONResponseDecoder: ResponseDecoderProtocol {
    
    // MARK: - Private Properties
    
    private let jsonDecoder = JSONDecoder()

    // MARK: - API
    
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }
    
    // MARK: - Init
    
    public init() {}
}

// MARK: - RawDataResponseDecoder

public class RawDataResponseDecoder: ResponseDecoderProtocol {
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }

    // MARK: - API
    
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
    
    // MARK: - Init
    
    public init() {}

}
