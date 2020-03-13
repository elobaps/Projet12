//
//  URLSessionFake.swift
//  Projet12Tests
//
//  Created by Elodie-Anne Parquer on 11/03/2020.
//  Copyright © 2020 Elodie-Anne Parquer. All rights reserved.
//

import Foundation

final class URLSessionFake: URLSession {
    
    // MARK: - Properties
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    // MARK: - Methods
    
    override func dataTask(with url: URL, completionHandler:
        @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake(data: data,
        urlResponse: response, responseError: error, completionHandler: completionHandler)
        task.completionHandler = completionHandler
        return task
    }
    override func dataTask(with request: URLRequest, completionHandler:
        @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake(data: data,
        urlResponse: response, responseError: error, completionHandler: completionHandler)
        task.completionHandler = completionHandler
        return task
    }
}

final class URLSessionDataTaskFake: URLSessionDataTask {
    
    // MARK: - Properties
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?

    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    init(data: Data?, urlResponse: URLResponse?, responseError: Error?,
         completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
          self.completionHandler = completionHandler
          self.data = data
          self.urlResponse = urlResponse
          self.responseError = responseError
    }
    
    // MARK: - Methods
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }

    override func cancel() {}
}
