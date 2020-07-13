//
//  GitHubSearchRepositoryRequest.swift
//  WebCLISample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import Foundation

struct GitHubSearchRepositoryRequest: GitHubWebRequest {
    typealias Response = GitHubSearchResponse<GitHubRepository>
    
    enum SearchRepositorySort: String {
        case stars
        case forks
        case helpWantedIssues = "help-wanted-issues"
        case updated
    }
    
    let path: String = "/search/repositories"
    var queryItems: [URLQueryItem]?
    
    init(keyword: String, sort: SearchRepositorySort) {
        queryItems = [
            URLQueryItem(name: "q", value: keyword),
            URLQueryItem(name: "sort", value: sort.rawValue)
        ]
    }
}
