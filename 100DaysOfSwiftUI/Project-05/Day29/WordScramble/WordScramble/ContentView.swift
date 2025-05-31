//
//  ContentView.swift
//  WordScramble
//
//  Created by Bin Liu on 5/31/25.
//

import SwiftUI

struct ContentView: View {
    let people = ["Steph", "Kyrie", "Derrick", "Bin"]
    
    var body: some View {
        List {
            Text("Static Row")

            ForEach(people, id: \.self) {
                Text($0)
            }

            Text("Static Row")
        }
    }
}

#Preview {
    ContentView()
}
