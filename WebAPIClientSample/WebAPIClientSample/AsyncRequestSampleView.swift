//
//  AsyncRequestSampleView.swift
//  WebAPIClientSample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import SwiftUI

struct AsyncRequestSampleView: View {
    @ObservedObject var viewModel: SearchRepositoryViewModel = SearchRepositoryViewModel()
    
    var body: some View {
        List(viewModel.repositories) { repository in
            Text(repository.name)
        }
        .navigationBarTitle("AsyncRequestSample")
        .onAppear {
            self.viewModel.fetchRepository(with: "Swift")
        }
    }
}

struct AsyncRequestSampleView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncRequestSampleView()
    }
}
