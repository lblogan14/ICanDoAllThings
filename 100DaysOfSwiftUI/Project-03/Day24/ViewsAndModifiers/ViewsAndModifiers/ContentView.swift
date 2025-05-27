//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Bin Liu on 5/26/25.
//

import SwiftUI

struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.blue)
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
    
    func titled(with text: String) -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    var body: some View {
        Text("This is a title")
            .titled(with: "My Title")
        
        Color.blue
            .frame(width: 300, height: 200)
            .watermarked(with: "I Can Do All Things")
    }
}

#Preview {
    ContentView()
}
