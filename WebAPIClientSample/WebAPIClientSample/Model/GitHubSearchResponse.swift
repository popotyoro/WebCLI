//
//  GitHubSearchResponse.swift
//  WebCLISample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import Foundation

struct GitHubSearchResponse<Item: Codable>: Codable {
    let totalCount: Int
    let items: [Item]
}
