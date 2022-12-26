//
//  DecodingUtils.swift
//  MovieAppTests
//
//  Created by Paul on 03/09/2022.
//

import XCTest

extension Decodable {
    static func from(file fileName: String, file: StaticString = #file, line: UInt = #line) -> Self? {
        return FileParser.loadJson(filename: fileName, file: file, line: line)
    }
}

fileprivate class FileParser {
    static func loadJson<T: Decodable>(filename fileName: String, file: StaticString = #file, line: UInt = #line) -> T? {
        do {
            guard let data = Data.from(file: fileName, testFile: file, line: line) else {
                XCTFail("Failed to parse json file: \(fileName), reason: failed to load file", file: file, line: line)
                return nil
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            XCTFail("Failed to parse json file: \(fileName), reason: \(error)", file: file, line: line)
            return nil
        }
    }
}

extension Data {
    static func from(file: String, testFile: StaticString = #file, line: UInt = #line) -> Data? {
        guard let url = Bundle(for: FileParser.self).url(forResource: file, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            XCTFail("Failed to parse json file: \(file)", file: testFile, line: line)
            return nil
        }
        
        return data
    }
}
