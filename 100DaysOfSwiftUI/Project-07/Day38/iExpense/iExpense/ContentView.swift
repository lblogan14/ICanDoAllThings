//
//  ContentView.swift
//  iExpense
//
//  Created by Bin Liu on 6/4/25.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    // add an initializer
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    // Similar to the AddView, we can get the user's preferred currency code
    // and use it in the ContentView.
    // This is not strictly necessary here, but it's a good practice
    // to ensure consistency across the app.
    var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }

    var body: some View {
        NavigationStack {
            List {
                // "Personal" expenses secion
                Section("Personal") {
                    ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: currencyCode)) // Use the currency code from user's locale
                                // modify the text color based on the amount
                                .foregroundColor(item.amount < 10 ? .green : item.amount < 100 ? .orange : .red)
                                // modify the font weight based on the amount
                                .font(item.amount < 10 ? .body : item.amount < 100 ? .body.bold() : .body.weight(.heavy))
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, for: "Personal")
                    }
                }
                
                // "Business" expenses section
                Section("Business") {
                    ForEach(expenses.items.filter { $0.type == "Business"}) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text(item.amount, format:.currency(code: currencyCode)) // Use the currency code from user's locale
                            // modify the text color based on the amount
                                .foregroundColor(item.amount < 10 ? .green : item.amount < 100 ? .orange : .red)
                            // modify the font weight based on the amount
                                .font(item.amount < 10 ? .body : item.amount < 100 ? .body.bold() : .body.weight(.heavy))
                        }
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, for: "Business")
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense.toggle()
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet, for type: String) {
        let filteredItems = expenses.items.enumerated().filter { $0.element.type == type }
        let indices = offsets.map { filteredItems[$0].offset }
        for index in indices.sorted(by: >) {
            expenses.items.remove(at: index)
        }
    }
}

#Preview {
    ContentView()
}
