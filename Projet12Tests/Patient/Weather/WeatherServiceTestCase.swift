//
//  Projet12Tests.swift
//  Projet12Tests
//
//  Created by Elodie-Anne Parquer on 10/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

@testable import Projet12
import XCTest

class WeatherServiceTestCase: XCTestCase {
    
    func testGetWeather_WhenErrorIsOccured_ThenShouldReturnFailedCallBack() {
        //Given
        let weatherService = WeatherService(session:
            URLSessionFake(data: nil, response: nil, error: FakeResponseData.errorWeather))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather { result in
            guard case .failure(let error) = result else {
                XCTFail("The rate recovery request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeather_WhenDataIsNil_ThenShouldReturnFailedCallBack() {
        //Given
        let weatherService = WeatherService(session:
            URLSessionFake(data: nil, response: nil, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        weatherService.getWeather { result in
            guard case .failure(let error) = result else {
                XCTFail("The weather request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeather_WhenResponseIsInccorect_ThenShouldReturnFailedCallBack() {
        //Given
        let weatherService = WeatherService(session:
            URLSessionFake(data: FakeResponseData.weatherCorrectData,
                           response: FakeResponseData.responseKO, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather { result in
            guard case .failure(let error) = result else {
                XCTFail("The weather request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeather_WhenDataIsInccorect_ThenShouldReturnFailedCallBack() {
        //Given
        let weatherService = WeatherService(session:
            URLSessionFake(data: FakeResponseData.weatherIncorrectData,
                           response: FakeResponseData.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather { result in
            guard case .failure(let error) = result else {
                XCTFail("The weather request method with an error failed")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetWeather_WhenCorrectDataAndResponseArePassed_ThenShouldReturnFailedCallBack() {
        //Given
        let weatherService = WeatherService(session:
            URLSessionFake(data: FakeResponseData.weatherCorrectData,
                           response: FakeResponseData.responseOK, error: nil))
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather { result in
            guard case .success(let results) = result else {
                XCTFail("The weather request method with an error failed")
                return
            }
            XCTAssertNotNil(results.main.temp)
            XCTAssertEqual(results.weather[0].weatherDescription, "couvert")
            XCTAssertNotNil(results.weather[0].icon)

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
