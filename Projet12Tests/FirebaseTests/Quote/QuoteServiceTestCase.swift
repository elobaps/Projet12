//
//  QuoteServiceTestCase.swift
//  Projet12Tests
//
//  Created by Elodie-Anne Parquer on 11/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

@testable import Projet12
import XCTest

class QuoteServiceTestCase: XCTestCase {
    
    func testGetQuote_WhenErrorIsOccured_ThenShouldReturnFailedCallBack() {
        //Given
        let quoteService = QuoteService(session:
            URLSessionFake(data: nil, response: nil, error: FakeResponseData.errorQuote))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        quoteService.getQuote { result in
            guard case .failure(let error) = result else {
                XCTFail("The quote request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuote_WhenDataIsNil_ThenShouldReturnFailedCallBack() {
        //Given
        let quoteService = QuoteService(session:
            URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        quoteService.getQuote { result in
            guard case .failure(let error) = result else {
                XCTFail("The quote request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuote_WhenResponseIsInccorect_ThenShouldReturnFailedCallBack() {
        //Given
        let quoteService = QuoteService(session:
            URLSessionFake(data: FakeResponseData.quoteCorrectData,
                           response: FakeResponseData.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { result in
            guard case .failure(let error) = result else {
                XCTFail("The quote request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetQuote_WhenDataIsInccorect_ThenShouldReturnFailedCallBack() {
        //Given
        let quoteService = QuoteService(session:
            URLSessionFake(data: FakeResponseData.quoteIncorrectData,
                           response: FakeResponseData.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { result in
            guard case .failure(let error) = result else {
                XCTFail("The quote request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
       func testGetQuote_WhenCorrectDataAndResponseArePassed_ThenShouldReturnFailedCallBack() {
        //Given
        let quoteService = QuoteService(session:
            URLSessionFake(data: FakeResponseData.quoteCorrectData,
                           response: FakeResponseData.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        quoteService.getQuote { result in
            guard case .success(let results) = result else {
                XCTFail("The quote request method with an error failed")
                return
            }
            
            XCTAssertEqual(results.quoteText, "You cannot have what you do not want.")
            XCTAssertEqual(results.quoteAuthor, "John Acosta")

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
