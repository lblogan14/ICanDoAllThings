//
//  ContentView.swift
//  Moonshot
//
//  Created by Bin Liu on 6/14/25.
//

import SwiftUI

struct CustomText: View {
    let text: String

    var body: some View {
        Text(text)
    }

    init(_ text: String) {
        print("Create a new CustomText")
        self.text = text
    }
}

struct ContentView: View {
    var body: some View {
        /*
        NavigationStack {
            List(0..<10) { row in
                NavigationLink("Row \(row)") {
                    Text("Detail \(row)")
                }
            }
            .navigationTitle("SwiftUI")
        }
        */
        /*
        Image(.archer)
            .resizable()
            .scaledToFit()
            .containerRelativeFrame(.horizontal) { size, axis in
                size * 0.8
            }
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(0..<10) {
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
            // add here
            .frame(maxWidth: .infinity)
        }
        
        ScrollView {
            LazyHStack(spacing: 10) {
                ForEach(0..<10) {
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
        }
         */
        let layout = [
            GridItem(.adaptive(minimum: 80, maximum: 120))
        ]
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(0..<10) {
                    Text("Item \($0)")
                }
            }
        }
        
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout) {
                ForEach(0..<10) {
                    Text("Item \($0)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
