//
//  WebResponse.swift
//  WebCLI
//
//  Created by popota on 2020/07/09.
//

import Foundation

typealias WebReqestResult = Result<WebResponse, APIError>

enum HTTPStatus {
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

enum APIError: Error {
    case parseError(error: Error)
    case noResponse
    case connectionError(error: Error)
}

typealias WebResponse = (
    statusCode: HTTPStatus,
    headers: [String: String],
    body: Data
)
