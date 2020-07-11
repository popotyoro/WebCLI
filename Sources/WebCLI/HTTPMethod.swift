//
//  HTTPMethod.swift
//  WebCLI
//
//  Created by popota on 2020/07/09.
//

import Foundation

public enum HTTPMethodAndPayload {
    case get
    case post(payload: Data?)
    
    var method: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
    
    var body: Data? {
        switch self {
        case .get:
            return nil
        case .post(let payload):
            return payload
        }
    }
}
