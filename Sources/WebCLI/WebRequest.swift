//
//  WebRequest.swift
//  WebCLI
//
//  Created by popota on 2020/07/09.
//

import Foundation

public protocol WebRequest {
    var baseURL: URL { get }
    var path: String { get }
    var methodAndPayload: HTTPMethodAndPayload { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String] { get }
}

extension WebRequest {
    func createURLRequest() -> URLRequest {
        
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        
        var urlReqeust = URLRequest(url: url)
        urlReqeust.url = components?.url
        urlReqeust.allHTTPHeaderFields = headers
        urlReqeust.httpMethod = methodAndPayload.method
        urlReqeust.httpBody = methodAndPayload.body
        
        return urlReqeust
    }
}


