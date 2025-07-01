//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Bin Liu on 5/24/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    var body: some View {
        VStack {
            Button("Show Alert") {
                showingAlert = true
            }
            .alert("Important message", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please read this.")
            }
            Button("Button 1") {}
                .buttonStyle(.bordered)
            Button("Button 2", role: .destructive) {}
                .buttonStyle(.bordered)
            Button("Button 3") {}
                .buttonStyle(.borderedProminent)
            Button("Button 4", role: .destructive) {}
                .buttonStyle(.borderedProminent)
            Button("Button 5") {}
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            Button {
                print("Button was tapped")
            } label: {
                Text("Tap me!")
                    .padding()
                    .foregroundStyle(.white)
                    .background(.purple)
            }
            Button {
                print("Edit button was tapped")
            } label: {
                Image(systemName: "pencil")
            }
            
            Button {
                print("Edit button was tapped")
            } label: {
                Label("Edit", systemImage: "pencil")
                    .padding()
                    .foregroundStyle(.white)
                    .background(.yellow)
            }
            
            
        }
    }
}

#Preview {
    ContentView()
}
