@testable import NetworkingKit
import XCTest

struct StubResponseDTO: Codable, Equatable {
    let page: Int
    let results: [StubDTO]
}

struct StubDTO: Codable, Equatable {
    let title: String
}

let stubData = """
    {
        "page": 1,
        "results": [
            {
                "title": "Stub"
            }
        ]
    }
""".data(using: .utf8)!

class DataTransferServiceTests: XCTestCase {
    
    typealias Sut = DataTransferService<StubResponseDTO>
    
    private enum ReturnedResult {
        case success
        case failure
    }
    
    private enum DataTransferErrorMock: Error {
        case someError
    }

    private var networkService: NetworkServiceMock?
    private var sut: Sut?
    
    private var expectedReturnedURLSessionTask: URLSessionTask?
    private var returnedURLSessionTask: URLSessionTask?
    
    private var sentURLRequest: URLRequest?
    private var urlRequestReceivedByNetworkService: URLRequest?
    
    private var expectedResponseDTO = StubResponseDTO(page: 1, results: [StubDTO(title: "Stub")])
    private var returnedResponseDTO: StubResponseDTO?
    
    private var returnedResult: ReturnedResult?
    private var returnedError: Error?

    private func completion(_ result: Sut.ResultValue) {
        switch result {
        case .success(let returnedDTO):
            self.returnedResult = .success
            self.returnedResponseDTO = returnedDTO
        case .failure(let returnedError):
            self.returnedResult = .failure
            self.returnedError = returnedError
        }
    }

    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        self.networkService = NetworkServiceMock()
        self.sut = DataTransferService(networkService: self.networkService!)
    }
    
    override func tearDown() {
        self.networkService = nil
        self.sut = nil
        
        self.expectedReturnedURLSessionTask = nil
        self.returnedURLSessionTask = nil
        
        self.sentURLRequest = nil
        self.urlRequestReceivedByNetworkService = nil
        
        self.returnedResponseDTO = nil
        
        self.returnedResult = nil
        self.returnedError = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_DataTransferService_whenPerformsRequest_shouldReturnURLSessionTask() {
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureReturnsURLSessionTask()
    }
    
    func test_DataTransferService_whenPerformsRequest_shouldCallNetworkServiceExactlyOnce() {
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureNetworkServiceCalledExactlyOnce()
    }
    
    func test_DataTransferService_whenPerformsRequest_shouldReturnURLSessionTaskFromNetworkService() {
        givenExpectedNetworkRequestResponse()
                
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureReturnsURLSessionTaskFromNetworkService()
    }
    
    func test_DataTransferService_whenPerformsRequest_shouldPassRequestToNetworkService() {
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureRequestIsPassedToNetworkService()
    }
        
    func test_DataTransferService_whenPerformsRequest_shouldReturnResult() {
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureReturnsResult()
    }
    
    func test_DataTransferService_whenPerformsSuccessfulRequest_shouldReturnSuccessResultInCompletionHandler() {
        // when
        whenPerformsSuccessfulRequest()
        
        // then
        thenEnsureReturnsSuccessResult()
    }
    
    func test_DataTransferService_whenPerformsFailedRequest_shouldReturnFailureResultInCompletionHandler() {
        // when
        whenPerformsFailedRequest()
        
        // then
        thenEnsureReturnsFailureResult()
    }
    
    func test_DataTransferService_whenPerformsSuccessfulRequest_shouldReturnDecodableObject() {
        // when
        whenPerformsSuccessfulRequest()
        
        // then
        thenEnsureReturnsGenres()
    }
    
    func test_DataTransferService_whenPerformsSuccessfulRequest_shouldReturnURLSessionTask() {
        // when
        whenPerformsSuccessfulRequest()
        
        // then
        thenEnsureReturnsURLSessionTask()
    }
    
    func test_DataTransferService_whenPerformsFailedRequest_shouldReturnURLSessionTask() {
        // when
        whenPerformsFailedRequest()
        
        // then
        thenEnsureReturnsURLSessionTask()
    }
    
    func test_DataTransferService_whenPerformsFailedRequest_shouldReturnErrorInFailureResult() {
        // when
        whenPerformsFailedRequest()
        
        // then
        thenEnsureReturnsError()
    }
    
//    func test_DataTransferService_whenPerformFailedRequest_shouldReturnSpecificDataTransferErrorInFailureResult() {
//        // given
//        let expectedError = NetworkError.generic(DataTransferErrorMock.someError)
//        self.networkService?.requestCompletionReturnValue = .failure(expectedError)
//
//        // when
//        whenNetworkRequestIsPerformed()
//
//        // then
//        guard let returnedError = self.returnedError else {
//            XCTFail("Should always be non-nil value at this point")
//            return
//        }
//
//        let networkError: NetworkError?
//        if returnedError is NetworkError {
//            networkError = returnedError as? NetworkError
//        }
//
//        guard let networkError = networkError else {
//            return
//        }
//
//
//        if case NetworkError.generic(DataTransferErrorMock.someError) = returnedError {
//            XCTAssertEqual(expectedError, networkError)
//        }
//    }
    
    func test_DataTransferService_whenPerformsFailedRequest_shouldCallNetworkServiceExactlyOnce() {
        // when
        whenPerformsFailedRequest()
        
        // then
        thenEnsureNetworkServiceCalled(numberOfTimes: 1)
    }
    
    func test_DataTransferService_whenPerformsMultipleFailedRequests_shouldCallNetworkServiceEqualNumberOfTimes() {
        // when
        whenPerformsFailedRequest()
        whenPerformsFailedRequest()

        // then
        thenEnsureNetworkServiceCalled(numberOfTimes: 2)
    }

    func test_DataTransferService_whenPerformsSuccessfulRequest_shouldCallNetworkServiceExactlyOnce() {
        // when
        whenPerformsSuccessfulRequest()
        
        // then
        thenEnsureNetworkServiceCalled(numberOfTimes: 1)
    }
    
    func test_DataTransferService_whenPerformsMultipleSuccessfulRequests_shouldCallRequestPerformerEqualNumberOfTimes() {
        // when
        whenPerformsSuccessfulRequest()
        whenPerformsSuccessfulRequest()

        // then
        thenEnsureNetworkServiceCalled(numberOfTimes: 2)
    }
    
    func test_Decoding_whenPerformsSuccessfulRequest_shouldDecodeDataReceivedFromNetwork() {
        // when
        whenPerformsSuccessfulRequest()
        
        // then
        thenEnsureDecodesDataIntoExpectedObject()
    }
    
    
    
    // TODO: Tests

    // URLRequests should in some cases be replaced by a protocol-driven Endpoint

    // should resolve errors

    // errors should be resolved by dedicated DataTransferErrorResolver

    // DataTransferErrorResolver should have its own tests

    
    
    
    
    // DataTransferService should keep logs of failures to unwrap

    // DataTransferService should have a logger

    // DataTransferErrorLogger should have its own tests

    
    
    
    
    // GenreRepository should instead go to DataTransferService for [Genre]

    

    // Generic network should be extensively tested to ensure it can decode objects of all types implemented in the Domain layer

    
    // MARK: - Given
    
    private func givenExpectedNetworkRequestResponse(of urlSessionTask: URLSessionTask? = nil) {
        self.expectedReturnedURLSessionTask = urlSessionTask ?? URLSessionTask()
        self.networkService?.requestReturnValue = expectedReturnedURLSessionTask
    }
    
    // MARK: - When
    
    private func whenNetworkRequestIsPerformed() {
        self.performRequest()
    }
    
    private func whenPerformsSuccessfulRequest() {
        self.createMockSuccessfulResponseFromNetworkService()
        self.performRequest()
    }
    
    private func whenPerformsFailedRequest() {
        self.networkService?.requestCompletionReturnValue = .failure(NetworkError.someError)
        self.performRequest()
    }
        
    // MARK: - Then
    
    private func thenEnsureReturnsURLSessionTask(file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(self.returnedURLSessionTask, file: file, line: line)
    }
    
    private func thenEnsureNetworkServiceCalledExactlyOnce(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self.networkService?.requestCallsCount, 1, file: file, line: line)
    }
    
    private func thenEnsureReturnsURLSessionTaskFromNetworkService(file: StaticString = #file, line: UInt = #line) {
        guard
            let expectedReturnedURLSessionTask = self.expectedReturnedURLSessionTask,
            let returnedURLSessionTask = self.returnedURLSessionTask
        else {
            throwPreconditionFailureWhereVariableShouldNotBeNil()
            return
        }
        
        XCTAssertEqual(expectedReturnedURLSessionTask, returnedURLSessionTask, file: file, line: line)
    }
    
    private func thenEnsureRequestIsPassedToNetworkService(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(urlRequest(), networkService?.requestReceivedRequest, file: file, line: line)
    }
    
    private func thenEnsureReturnsResult(file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(self.returnedResult, file: file, line: line)
    }
    
    private func thenEnsureReturnsSuccessResult(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self.returnedResult, .success, file: file, line: line)
    }

    private func thenEnsureReturnsFailureResult(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self.returnedResult, .failure, file: file, line: line)
    }
    
    private func thenEnsureReturnsGenres(file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(self.returnedResponseDTO, file: file, line: line)
    }
    
    private func thenEnsureReturnsError(file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(self.returnedError, file: file, line: line)
    }
    
    private func thenEnsureNetworkServiceCalled(numberOfTimes expectedCalls: Int, file: StaticString = #file, line: UInt = #line) {
        let actualCalls = self.networkService?.requestCallsCount
        XCTAssertEqual(expectedCalls, actualCalls, file: file, line: line)
    }
    
    private func thenEnsureDecodesDataIntoExpectedObject(file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(self.expectedResponseDTO, self.returnedResponseDTO, file: file, line: line)
    }
    
    // MARK: - Test Setup Errors
    
    private func throwPreconditionFailureWhereVariableShouldNotBeNil() {
        preconditionFailure("The test variable should not be nil at this point - check test setup and ensure variables are correctly initialised")
    }
    
    // MARK: - Helpers
    
    private func urlRequest() -> URLRequest? {
        URLRequest(url: URL(string: "www.expectedReturnValue.com")!)
    }
    
    private func performRequest() {
        self.returnedURLSessionTask = sut?.request(self.urlRequest()!, decoder: JSONResponseDecoder(), completion: self.completion(_:))
    }
    
    private func createMockSuccessfulResponseFromNetworkService() {
        self.networkService?.requestCompletionReturnValue = .success(stubData)
    }
}
