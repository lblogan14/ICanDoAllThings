//
//  ContentView.swift
//  Navigation
//
//  Created by Bin Liu on 6/26/25.
//

import SwiftUI

struct ContentView: View {
    @State private var title = "SwiftUI"

    var body: some View {
        NavigationStack {
            Text("Hello, world!")

            .navigationTitle($title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
