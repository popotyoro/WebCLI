//
//  GitHubWebAPIClienct.swift
//  WebCLISample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import Foundation
import WebCLI

typealias GitHubReqestResult<T: GitHubResponse> = Result<T, GitHubAPIError>
typealias GitHubResponse = Codable

enum GitHubAPIError: Error {
    case parseError
    case clientError(code: Int)
    case serverError(code: Int)
    case unexpectedStatusCode(code: Int)
    case apiError(APIError)
}

enum GitHubWebAPIClient {
    
    static func send<Request: GitHubWebRequest>(request: Request, completion: @escaping (GitHubReqestResult<Request.Response>) -> Void) {
        WebAPI.send(request: request) { result in
            completion(parseFrom(result: result))
        }
    }
    
    static func syncSend<Request: GitHubWebRequest>(request: Request) -> GitHubReqestResult<Request.Response> {
        let result = WebAPI.syncSend(request: request)
        return parseFrom(result: result)
    }
}

private extension GitHubWebAPIClient {
    static func parseFrom<T: Codable>(result: WebReqestResult) -> GitHubReqestResult<T> {
        switch result {
        case .success(let response):
            switch response.statusCode {
            case .ok(code: _):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let json = try? decoder.decode(T.self, from: response.body) else {
                    return .failure(.parseError)
                }
                return .success(json)
                
            case .info(let code), .redirect(let code), .unknown(let code):
                return .failure(.unexpectedStatusCode(code: code))
                
            case .clientError(let code):
                return .failure(.clientError(code: code))
                
            case .serverError(let code):
                return .failure(.serverError(code: code))
            }
            
        case .failure(let error):
            return .failure(.apiError(error))
            
        }
    }
}
