//
//  SyncRequestSampleView.swift
//  WebAPIClientSample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import SwiftUI

struct SyncRequestSampleView: View {
    @ObservedObject var viewModel: SearchRepositoryViewModel = SearchRepositoryViewModel()
    
    var body: some View {
        List(viewModel.repositories) { repository in
            Text(repository.name)
        }
        .navigationBarTitle("SyncRequestSample")
        .onAppear {
            self.viewModel.syncRepository(with: "Rust")
        }
    }
}

struct SyncRequestSampleView_Previews: PreviewProvider {
    static var previews: some View {
        SyncRequestSampleView()
    }
}
