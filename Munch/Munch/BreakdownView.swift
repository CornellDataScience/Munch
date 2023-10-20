//
//  BreakdownView.swift
//  Munch
//
//  Created by elizabeth song on 10/19/23.
//

import SwiftUI
import Charts

struct MacroNutrient: Identifiable {
    let id = UUID()
    let name: String
    let amountg: Double
    let percentage: Double
}

struct BreakdownView: View {
    @State private var selectedRange: ClosedRange<Int>?
    @State private var numbers = (0..<10)
        .map { _ in Double.random(in: 0...10) }
    @State private var macronutrients = [MacroNutrient(name: "Protein",
                                                       amountg: 12.3,
                                                       percentage: 15.5),
                                         MacroNutrient(name: "Carbohydrates",
                                                       amountg: 12.3,
                                                       percentage: 15.5),
                                         MacroNutrient(name: "Fat",
                                                       amountg: 12.3,
                                                       percentage: 15.5),
    ]
    @State private var selection: MacroNutrient.ID? = nil
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            Chart {
                BarMark(
                    x: .value("Macro Category", data[0].type),
                    y: .value("% DV", data[0].percentage)
                ).foregroundStyle(.green)
                BarMark(
                    x: .value("Macro Category", data[1].type),
                    y: .value("% DV", data[1].percentage)
                ).foregroundStyle(.purple)
                BarMark(
                    x: .value("Macro Category", data[2].type),
                    y: .value("% DV", data[2].percentage)
                ).foregroundStyle(.pink)
                
            }.padding(.top)
                .frame(width: 300, height: 300)
            .chartXAxisLabel("Macronutrient Name", alignment: .center)
            .chartYAxisLabel("% of Daily Value")
            .chartYAxis {
                AxisMarks(
                    values: [0, 50, 100]
                ) {
                    AxisValueLabel(format: Decimal.FormatStyle.Percent.percent.scale(1))
                }
                
                AxisMarks(
                    values: [0, 25, 50, 75, 100]
                ) {
                    AxisGridLine()
                }
            }
        } else {
            Text("Charts only available in iOS 16.0+")
        }

        if #available(iOS 16.0, *) {
            Table(macronutrients)
            {
                TableColumn("Name", value: \.name)
                TableColumn("Amount (grams)") { macronutrient in
                    Text("\(macronutrient.amountg)")
                }
                TableColumn("Percent of Daily Value (DV)") { macronutrient in
                    Text("\(macronutrient.percentage)")
                }
            }
        } else {
        }
        
        
        
    }
    
    
    struct ValuePerCategory {
        var type: String
        var percentage: Double
    }
    
    
    var data: [ValuePerCategory] = [
        .init(type: "Carbohydrates", percentage: 5),
        .init(type: "Fat", percentage: 9),
        .init(type: "Protein", percentage: 7)
    ]
    /*
     #Preview {
     BreakdownView()
     }
     */
}
