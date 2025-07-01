//
//  ContentView.swift
//  Navigation
//
//  Created by Bin Liu on 6/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        /*
        NavigationStack {
            NavigationLink("Tap Me") {
                DetailView(number: 14)
            }
        }
        */
        NavigationStack {
            List(0..<100) { i in
                NavigationLink("Select \(i)", value: i)
            }
            // add navigationDestination here
            .navigationDestination(for: Int.self) { selection in
                Text("You selected \(selection)")
            }
        }
    }
}

struct DetailView: View {
    var number: Int

    var body: some View {
        Text("Detail View \(number)")
    }

    init(number: Int) {
        self.number = number
        print("Creating detail view \(number)")
    }
}

#Preview {
    ContentView()
}
