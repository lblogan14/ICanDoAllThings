//
//  ContentView.swift
//  UnitConversion
//
//  Created by Bin Liu on 5/24/25.
//

import SwiftUI

struct ContentView: View {
    // unit array
    let units = ["meters", "kilometers", "feet", "yard", "miles"]
    // selected input unit
    @State private var inputUnit = "meters"
    // selected output unit
    @State private var outputUnit = "kilometers"
    // input value
    @State private var inputValue = 0.0

    // conversion rates
    let conversionRates: [String: Double] = [
        "meters": 1.0,
        "kilometers": 0.001,
        "feet": 3.28084,
        "yard": 1.09361,
        "miles": 0.000621371
    ]
    // conversion function
    var outputValue: Double {
        let inputRate = conversionRates[inputUnit] ?? 1.0
        let outputRate = conversionRates[outputUnit] ?? 1.0
        let result = inputValue * inputRate / outputRate
        return result
    }

    var body: some View {
        Form {
            Section(header: Text("Input Unit")) {
                TextField(
                    "Enter input value",
                    value: $inputValue,
                    format: .number
                )
                Picker("Select Input Unit", selection: $inputUnit) {
                    ForEach(units, id: \.self) {
                        Text($0)
                    }
                }
            }
            
            Section(header: Text("Output Unit")) {
                Picker("Select Output Unit", selection: $outputUnit) {
                    ForEach(units, id: \.self) {
                        Text($0)
                    }
                }
                Text(
                    String(format: "%.4f", outputValue)
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
