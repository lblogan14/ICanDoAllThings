//
//  ContentView.swift
//  WeSplit
//
//  Created by Bin Liu on 5/20/25.
//

import SwiftUI

struct ContentView: View {
  let students = ["Steph", "Kyrie", "Derrick"]
  @State private var selectedStudent = "Steph"
  
  var body: some View {
    NavigationStack {
      Form {
        Picker("Select your student", selection: $selectedStudent) {
          ForEach(students, id: \.self) {
            Text($0)
          }
        }
      }
    }
  }
}

#Preview {
    ContentView()
}
