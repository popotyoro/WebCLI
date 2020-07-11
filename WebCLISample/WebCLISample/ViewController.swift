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
        
        let result: Result<[GitHubRepository], GitHubAPIError> = GitHubWebAPIClient.syncSend(request: repositoryRequest)
        print(result)
    }
}

