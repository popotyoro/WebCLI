//
//  SearchRepositoryViewModel.swift
//  WebAPIClientSample
//
//  Created by popota on 2020/07/13.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import Foundation

class SearchRepositoryViewModel: ObservableObject {
    
    @Published var repositories: [GitHubRepository] = []
    
    func fetchRepository(with keyword: String) {
        let requet = GitHubSearchRepositoryRequest(keyword: keyword, sort: .stars)
        GitHubWebAPIClient.send(request: requet) { (result) in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    self.repositories = item.items
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func syncRepository(with keyword: String) {
        let requet = GitHubSearchRepositoryRequest(keyword: keyword, sort: .stars)
        let result = GitHubWebAPIClient.syncSend(request: requet)
        switch result {
        case .success(let item):
            DispatchQueue.main.async {
                self.repositories = item.items
            }
        case .failure(let error):
            print(error)
        }
    }
}
