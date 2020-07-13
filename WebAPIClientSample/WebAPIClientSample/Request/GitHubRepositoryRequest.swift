//
//  GitHubRepositoryRequest.swift
//  WebCLISample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import Foundation

struct GitHubRepositoryRequest: GitHubWebRequest {
    typealias Response = [GitHubRepository]
    
    let path: String = "/users/popotyoro/repos"
    var queryItems: [URLQueryItem]? = nil
}
