//
//  GitHubRepository.swift
//  WebCLISample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import Foundation

struct GitHubRepository: Codable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let url: String
    let owner: GitHubOwner
}
