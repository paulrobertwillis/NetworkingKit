//
//  ResponseDecoderTests.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import XCTest

class JSONResponseDecoderTests: XCTestCase {
    
    private var sut: JSONResponseDecoder?
    
    private let objectAsData = """
        {
            "forename": "Anon",
            "surname": "Ymous"
        }
        """.data(using: .utf8)!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        self.sut = JSONResponseDecoder()
    }
    
    override func tearDown() {
        self.sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
        
    func test_Decoding_whenPassedDecodableData_shouldReturnDecodedObject() {
        guard let sut = sut else { XCTFail("sut should be non optional"); return }
        
        struct User: Codable {
            let forename: String
            let surname: String
        }

        do {
            // When
            let forename = "Anon"
            let surname = "Ymous"
            let user: User = try sut.decode(self.objectAsData)

            // Then
            XCTAssertEqual(user.forename, forename)
            XCTAssertEqual(user.surname, surname)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
}
