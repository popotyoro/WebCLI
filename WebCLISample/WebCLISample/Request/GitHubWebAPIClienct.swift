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
    case apiError(error: APIError)
}

enum GitHubWebAPIClient {
    
    static func send<Response: GitHubResponse>(request: GitHubWebRequest, completion: @escaping (GitHubReqestResult<Response>) -> Void) {
        WebAPI.send(request: request) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let json = try? decoder.decode(Response.self, from: response.body) else {
                    completion(.failure(.parseError))
                    return
                }
                
                completion(.success(json))
                
            case .failure(let error):
                completion(.failure(.apiError(error: error)))
                
            }
        }
    }
    
    static func syncSend<Response: GitHubResponse>(request: GitHubWebRequest) -> GitHubReqestResult<Response> {
        
        let result = WebAPI.syncSend(request: request)
        
        switch result {
        case .success(let response):
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let json = try? decoder.decode(Response.self, from: response.body) else {
                return .failure(.parseError)
            }
            
            return .success(json)
            
        case .failure(let error):
            return .failure(.apiError(error: error))
            
        }
    }
}
