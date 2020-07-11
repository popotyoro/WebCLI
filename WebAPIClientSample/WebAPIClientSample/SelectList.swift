//
//  SelectList.swift
//  WebAPIClientSample
//
//  Created by popota on 2020/07/11.
//  Copyright © 2020 Tagayasu. All rights reserved.
//

import SwiftUI

struct SelectList: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AsyncRequestSampleView()) {
                    Text("Async Request")
                }
                NavigationLink(destination: SyncRequestSampleView()) {
                    Text("Sync Request")
                }
            }
        .navigationBarTitle("RequestSample")
        }
    }
}

struct SelectList_Previews: PreviewProvider {
    static var previews: some View {
        SelectList()
    }
}
