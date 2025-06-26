//
//  ContentView.swift
//  Navigation
//
//  Created by Bin Liu on 6/23/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path = [Int]()
    @State private var pathStore = PathStore()

    var body: some View {
        /*
        NavigationStack(path: $path) {
            List {
                ForEach(0..<5) { i in
                    NavigationLink("Select Number: \(i)", value: i)
                }

                ForEach(0..<5) { i in
                    NavigationLink ("Select String: \(i)", value: String(i))
                }
            }
            .navigationDestination(for: Int.self) { selection in
                Text("You selected the number \(selection)")
            }
            .navigationDestination(for: String.self) { selection in
                Text("You selected the string \(selection)")
            }
            .toolbar {
                Button("Push 556") {
                    path.append(556)
                }

                Button("Push Hello") {
                    path.append("Hello")
                }
            }
        }
        */
        
        NavigationStack(path: $pathStore.path) {
                    DetailView(number: 0)
                        .navigationDestination(for: Int.self) { i in
                            DetailView(number: i)
                        }
        }
    }
}

@Observable
class PathStore {
    // 1. path has to be NavigationPath
    var path: NavigationPath {
        didSet {
            save()
        }
    }

    private let savePath = URL.documentsDirectory.appending(path: "SavedPath")

    init() {
        if let data = try? Data(contentsOf: savePath) {
            // 2. Need to decode to a specific type
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) {
                path = NavigationPath(decoded)
                return
            }
        }

        // fallback
        // 3. assign an empty `NavigationPath`
        path = NavigationPath()
    }

    func save() {
        // 4. add a check to retrieve the `Codable` navigation path
        guard let representation = path.codable else { return }

        do {
            // 5. convert to JSON
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch {
            print("Failed to save navigation data")
        }
    }
}

struct DetailView: View {
    var number: Int

    var body: some View {
        NavigationLink("Go to Random Number", value: Int.random(in: 1...1000))
            .navigationTitle("Number: \(number)")
    }
}

#Preview {
    ContentView()
}
