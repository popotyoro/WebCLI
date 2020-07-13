//
//  WebResponse.swift
//  WebCLI
//
//  Created by popota on 2020/07/09.
//

import Foundation

public typealias WebReqestResult = Result<WebResponse, APIError>

public enum HTTPStatus {
    case info(code: Int)
    case ok(code: Int)
    case redirect(code: Int)
    case clientError(code: Int)
    case serverError(code: Int)
    case unknown
    
    init(statusCode: Int) {
        switch statusCode {
        case 100...199:
            self = .info(code: statusCode)
        case 200...299:
            self = .ok(code: statusCode)
        case 300...399:
            self = .redirect(code: statusCode)
        case 400...499:
            self = .clientError(code: statusCode)
        case 500...599:
            self = .serverError(code: statusCode)
        default:
            self = .unknown
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
