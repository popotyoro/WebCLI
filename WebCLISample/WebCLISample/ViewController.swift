//
//  ViewController.swift
//  WebCLISample
//
//  Created by popota on 2020/07/09.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import UIKit
import WebCLI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let repositoryRequest = GitHubRepositoryRequest()
        
        GitHubWebAPIClient.send(request: repositoryRequest){ (result: Result<[GitHubRepository], GitHubAPIError>) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
}

