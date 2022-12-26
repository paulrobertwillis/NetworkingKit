//
//  NetworkServiceTests.swift
//  MovieAppTests
//
//  Created by Paul on 15/06/2022.
//

import XCTest

public enum NetworkErrorMock: Error {
    case someError
}

class NetworkServiceTests: XCTestCase {
    
    private enum ReturnedResult {
        case success
        case failure
    }
        
    private var networkRequestPerformer: NetworkRequestPerformerMock?
    private var logger: NetworkLoggerMock = NetworkLoggerMock()

    private var sut: NetworkService?
    
    private var request: URLRequest?
    private var task: URLSessionTask?
    
    private var expectedError: NetworkErrorMock?
    
    private var returnedResult: ReturnedResult?
    private var returnedValue: [Genre]?
    private var returnedData: Data?
    private var returnedError: Error?
    
    private func completion(_ result: NetworkServiceProtocol.ResultValue) {
        switch result {
        case .success(let returnedData):
            self.returnedResult = .success
            self.returnedData = returnedData
        case .failure(let returnedError):
            self.returnedResult = .failure
            self.returnedError = returnedError
        }
    }
        
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        self.networkRequestPerformer = nil
//        self.logger = nil
        
        self.sut = nil
        
        self.request = nil
        self.task = nil
        
        self.expectedError = nil
        
        self.returnedResult = nil
        self.returnedValue = nil
        self.returnedError = nil
        
        super.tearDown()
    }

    // MARK: - Tests
    
    func test_NetworkService_whenPerformsSuccessfulRequest_shouldReturnSuccessfulResultInCompletionHandler() {
        // given
        givenRequestWillSucceed()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureSuccessfulResultIsReturnedInCompletionHandler()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnFailedResultInCompletionHandler() {
        // given
        givenRequestWillFail()
                
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureFailureResultIsReturnedInCompletionHandler()
    }
    
    func test_NetworkService_whenPerformsRequest_shouldReturnURLSessionTask() {
        // given
        givenRequestWillFail()

        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureTaskIsReturned()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnAnErrorInFailedResultInCompletionHandler() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureAnyErrorIsReturnedInFailedResult()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnSpecificNetworkErrorInFailedResultInCompletionHandler() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureSpecificNetworkErrorIsReturnedInFailedResult()
    }
        
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnURLResponseInFailedResultInCompletionHandler() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureURLResponseIsReturnedInFailedResult()
    }
    
    func test_CompletionHandler_whenPerformsSuccessfulRequest_shouldReturnDataInCompletionHandler() {
        // given
        createRequestStub()
        givenRequestWillSucceed()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureDataIsReturnedInCompletionHandler()
    }
    
    // MARK: - Tests: RequestPerformerCallCount
    
    func test_RequestPerformerCallCount_whenPerformsSuccessfulRequest_shouldCallRequestPerformerExactlyOnce() {
        // given
        givenRequestWillSucceed()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureRequestPerformerCalled(numberOfTimes: 1)
    }
    
    func test_RequestPerformerCallCount_whenPerformsFailedRequest_shouldCallRequestPerformerExactlyOnce() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureRequestPerformerCalled(numberOfTimes: 1)
    }
    
    func test_RequestPerformerCallCount_whenPerformsMultipleRequests_shouldCallRequestPerformerTheSameNumberOfTimes() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureRequestPerformerCalled(numberOfTimes: 2)
    }
    
    func test_RequestPerformerCallCount_whenPerformsChainOfFailingAndSucceedingRequests_shouldCallRequestPerformerTheSameNumberOfTimes() {
        // given
        createRequestStub()
        
        // when
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()

        // then
        thenEnsureRequestPerformerCalled(numberOfTimes: 5)
    }
            
    // MARK: - Tests: LoggingRequestCallCount
    
    func test_LoggingRequestCallCount_whenPerformsSuccessfulRequest_shouldCallLoggerToLogRequestExactlyOnce() {
        // when
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogRequest(numberOfTimes: 1)
    }
    
    func test_LoggingRequestCallCount_whenPerformsFailedRequest_shouldCallLoggerToLogRequestExactlyOnce() {
        // when
        whenFailedNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogRequest(numberOfTimes: 1)
    }
    
    func test_LoggingRequestCallCount_whenPerformsMultipleSuccessfulRequests_shouldCallLoggerToLogRequestMultipleTimes() {
        // when
        whenSuccessfulNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogRequest(numberOfTimes: 2)
    }
    
    func test_LoggingRequestCallCount_whenPerformsMultipleFailedRequests_shouldCallLoggerToLogRequestMultipleTimes() {
        // when
        whenFailedNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogRequest(numberOfTimes: 2)
    }

    func test_LoggingRequestCallCount_whenPerformsMultipleSuccessfulAndFailedRequests_shouldCallLoggerToLogRequestMultipleTimes() {
        // when
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogRequest(numberOfTimes: 4)
    }
    
    // MARK: - Tests: LoggingResponseCallCount
    
    func test_LoggingResponseCallCount_whenPerformsSuccessfulRequest_shouldCallLoggerToLogResponseExactlyOnce() {
        // when
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogResponse(numberOfTimes: 1)
    }
    
    func test_LoggingResponseCallCount_whenPerformsFailedRequest_shouldCallLoggerToLogResponseExactlyOnce() {
        // when
        whenFailedNetworkRequestIsPerformed()
        
        // then
        thenEnsureLoggerCalledToLogResponse(numberOfTimes: 1)
    }
    
    func test_LoggingResponseCallCount_whenPerformsMultipleSuccessfulRequests_shouldCallLoggerToLogResponseMultipleTimes() {
        // when
        whenSuccessfulNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogResponse(numberOfTimes: 2)
    }
    
    func test_LoggingResponseCallCount_whenPerformsMultipleFailedRequests_shouldCallLoggerToLogResponseMultipleTimes() {
        // when
        whenFailedNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogResponse(numberOfTimes: 2)
    }

    func test_LoggingResponseCallCount_whenPerformsMultipleSuccessfulAndFailedRequests_shouldCallLoggerToLogResponseMultipleTimes() {
        // when
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        thenEnsureLoggerCalledToLogResponse(numberOfTimes: 4)
    }
    
    // TODO: Test that NetworkService passes specific requests and logs to the logger
    
    // MARK: - Tests: LogsCorrectRequests
    
    func test_LoggingCorrectRequest_whenPerformsSuccessfulRequest_shouldPassCorrectRequestToLogger() {
        // when
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        thenEnsureCorrectRequestIsPassedToLogger()
    }
        
    func test_LoggingCorrectRequest_whenPerformsFailedRequest_shouldPassCorrectRequestToLogger() {
        // when
        whenFailedNetworkRequestIsPerformed()

        // then
        XCTAssertEqual(self.request, self.logger.logRequestParameterReceived?.urlRequest)
    }

    // MARK: - Tests: LogsCorrectResponses
    
    func test_LoggingCorrectResponse_whenPerformsSuccessfulRequest_shouldPassCorrectResponseToLogger() {
        // given
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        thenEnsureCorrectResponseIsPassedToLogger()
    }
    
    func test_LoggingCorrectResponse_whenPerformsFailedRequest_shouldPassCorrectResponseToLogger() {
        // when
        whenFailedNetworkRequestIsPerformed()

        // then
        thenEnsureCorrectResponseIsPassedToLogger()
    }

    // MARK: - Given
        
    private func givenRequestWillSucceed() {
        createRequestStub()
        initialiseNetworkRequestPerformer(data: TMDBResponseMocks.Genres.getGenres.successResponse(), response: createSuccessResponseStub(), error: nil)
        initialiseNetworkService()
    }
    
    private func givenRequestWillFail() {
        createRequestStub()
        self.expectedError = NetworkErrorMock.someError
        initialiseNetworkRequestPerformer(data: nil, response: createFailureResponseStub(), error: NetworkErrorMock.someError)
        initialiseNetworkService()
    }
        
    // MARK: - When
    
    private func whenNetworkRequestIsPerformed() {
        self.task = self.sut?.request(request: self.request!, completion: self.completion(_:))
    }
    
    private func whenSuccessfulNetworkRequestIsPerformed() {
        givenRequestWillSucceed()
        whenNetworkRequestIsPerformed()
    }
    
    private func whenFailedNetworkRequestIsPerformed() {
        givenRequestWillFail()
        whenNetworkRequestIsPerformed()
    }
    
    // MARK: - Then
    
    private func thenEnsureSuccessfulResultIsReturnedInCompletionHandler() {
        XCTAssertEqual(self.returnedResult, .success)
    }
    
    private func thenEnsureFailureResultIsReturnedInCompletionHandler() {
        XCTAssertEqual(self.returnedResult, .failure)
    }
    
    private func thenEnsureTaskIsReturned() {
        XCTAssertNotNil(self.task)
    }
    
    private func thenEnsureAnyErrorIsReturnedInFailedResult() {
        XCTAssertNotNil(self.returnedError)
    }
    
    private func thenEnsureSpecificNetworkErrorIsReturnedInFailedResult() {
        guard let returnedError = returnedError else {
            XCTFail("Should always be non-nil value at this point")
            return
        }

        if case NetworkError.error(let statusCode) = returnedError {
            XCTAssertEqual(statusCode, self.createFailureResponseStub()?.statusCode)
        }
    }
    
    private func thenEnsureURLResponseIsReturnedInFailedResult() {
        guard let returnedError = returnedError else {
            XCTFail("Should always be non-nil value at this point")
            return
        }
        
        if case NetworkError.error(let statusCode) = returnedError {
            XCTAssertNotNil(statusCode)
        }
    }
        
    private func thenEnsureRequestPerformerCalled(numberOfTimes expectedCalls: Int) {
        let actualCalls = self.networkRequestPerformer?.requestCallsCount
        XCTAssertEqual(expectedCalls, actualCalls)
    }
    
    private func thenEnsureDataIsReturnedInCompletionHandler() {
        XCTAssertNotNil(self.returnedData)
    }
    
    private func thenEnsureLoggerCalledToLogRequest(numberOfTimes expectedCalls: Int) {
        XCTAssertEqual(expectedCalls, self.logger.logRequestCallsCount)
    }

    private func thenEnsureLoggerCalledToLogResponse(numberOfTimes expectedCalls: Int) {
        XCTAssertEqual(expectedCalls, self.logger.logResponseCallsCount)
    }
    
    private func thenEnsureCorrectRequestIsPassedToLogger() {
        XCTAssertEqual(self.request, self.logger.logRequestParameterReceived?.urlRequest)
    }

    private func thenEnsureCorrectResponseIsPassedToLogger() {
        XCTAssertEqual(self.networkRequestPerformer?.response, self.logger.logResponseParameterReceived?.urlResponse)
    }
    
    // MARK: - Helpers
    
    private func initialiseNetworkService() {
        self.sut = NetworkService(networkRequestPerformer: self.networkRequestPerformer!,
                                  logger: self.logger)
    }
    
    private func initialiseNetworkRequestPerformer(data: Data?, response: HTTPURLResponse?, error: Error?) {
        if self.networkRequestPerformer != nil { return }
        
        self.networkRequestPerformer = NetworkRequestPerformerMock(data: data,
                                                                   response: response,
                                                                   error: error)
    }
    
    private func createRequestStub() {
        self.request = URLRequest(url: URL(string: "www.test.com")!)
    }
    
    private func createSuccessResponseStub() -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
    }
    
    private func createFailureResponseStub() -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
    }
}


// TODO: NetworkService should have NetworkConfiguration that contains base URL, etc.

// TODO: Network Logger
// successful response should log whether data was successfully parsed
