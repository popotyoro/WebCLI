//
//  WebAPI.swift
//  WebCLI
//
//  Created by popota on 2020/07/09.
//

import Foundation

public enum WebAPI {
    public static func send(request: WebRequest, completion: @escaping (WebReqestResult) -> Void) {
        let urlRequest = request.createURLRequest()
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.connectionError(error: error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            let webResponse = createWebResponse(data: data, response: response)
            completion(.success(webResponse))
        }
        
        task.resume()
    }
}

private extension WebAPI {
    static func createWebResponse(data: Data, response: HTTPURLResponse) -> WebResponse {
        var headers: [String: String] = [:]
        response.allHeaderFields.forEach { (key, value) in
            headers[key.description] = String(describing: value)
        }
        
        return WebResponse(
            statusCode: HTTPStatus(statusCode: response.statusCode),
            headers: headers,
            body: data
        )
    }
}
