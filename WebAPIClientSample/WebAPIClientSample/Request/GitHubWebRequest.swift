//
//  GitHubWebRequest.swift
//  WebCLISample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import Foundation
import WebCLI

protocol GitHubWebRequest: WebRequest {
    associatedtype Response: GitHubResponse
}

extension GitHubWebRequest {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    var methodAndPayload: HTTPMethodAndPayload {
        .get
    }
    var headers: [String : String] {
      ["Authorization": "XXXXXXXXXXX"]
    }
}
