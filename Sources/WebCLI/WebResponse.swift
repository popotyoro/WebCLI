//
//  WebResponse.swift
//  WebCLI
//
//  Created by popota on 2020/07/09.
//

import Foundation

public typealias WebReqestResult = Result<WebResponse, APIError>

public enum HTTPStatus {
    case ok
    
    init(statusCode: Int) {
        switch statusCode {
        case 200:
            self = .ok
        default:
            self = .ok
        }
    }
}

public enum APIError: Error {
    case parseError(error: Error)
    case noResponse
    case connectionError(error: Error)
}

public typealias WebResponse = (
    statusCode: HTTPStatus,
    headers: [String: String],
    body: Data
)
