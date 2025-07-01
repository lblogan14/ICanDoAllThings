//
//  ContentView.swift
//  BetterRest
//
//  Created by Bin Liu on 5/28/25.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0

        return Calendar.current.date(from: components) ?? .now
    }
    
    var recommendedBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            // new date components
            let components = Calendar.current.dateComponents(
                [.hour, .minute],
                from: wakeUp
            )
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            // Core ML prediction
            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            return sleepTime.formatted(
                date: .omitted,
                time: .shortened
            )
        } catch {
            // something went wrong
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("When do you want to wake up?").textCase(.none)) {
                    DatePicker(
                        "Please enter a time",
                        selection: $wakeUp,
                        displayedComponents: .hourAndMinute
                    )
                    .labelsHidden()
                }
                
                Section(header: Text("Desired amount of sleep").textCase(.none)) {
                    Stepper(
                        "\(sleepAmount.formatted()) hours",
                        value: $sleepAmount,
                        in: 4...12,
                        step: 0.25
                    )
                }
                
                Section(header: Text("Daily coffee intake").textCase(.none)) {
                    Picker("Coffee intake", selection: $coffeeAmount) {
                        ForEach(1..<21) { amount in
                            Text("\(amount) cup\(amount > 1 ? "s" : "")")
                        }
                    }
                }
                
                Section(header: Text("Recommended Bedtime").textCase(.none)) {
                    Text(recommendedBedtime)
                        .font(.headline)
                        .foregroundColor(.blue)
                        
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
}

#Preview {
    ContentView()
}
