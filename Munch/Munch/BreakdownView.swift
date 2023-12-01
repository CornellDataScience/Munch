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
    let percentage : Double
}
struct URLImage: View{
    let urlString : String

    
    @State var data:Data?
    @State private var dvfat: Double = 0.0
    @State private var dvprotein: Double = 0.0
    @State private var dvcarbs: Double = 0.0

    
    var body: some View {
        if let data = data, let uiimage = UIImage(data:data){
            Image(uiImage:uiimage)
                .resizable()
                .frame(width: 130, height: 70)
                .background(Color.gray)
        } else {
            Image("")
                .frame(width:130, height:70)
                .background(Color.gray)
                .onAppear{
                    fetchData()
                }
        }
    }
    private func fetchData() {
        guard let url = URL(string:urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with:url) {
            data, _, _ in self.data = data
        }
        task.resume()
    }
}

struct BreakdownView: View {
    
    // this is pretty repetitive
    var ageFloat: Double {
        let age_string = UserDefaults.standard.string(forKey: "Age") ?? "0.0"
        return Double(age_string) ?? 0.0
    }
    var weightFloat: Double {
        let weight_string = UserDefaults.standard.string(forKey: "Weight") ?? "0.0"
        return Double(weight_string) ?? 0.0
    }
    var heightFloat: Double {
        let height_string = UserDefaults.standard.string(forKey: "Height") ?? "0.0"
        return Double(height_string) ?? 0.0
    }
    
    // harris-benedict equation??
    // we can change the equations later if these are wrong
    let gender = UserDefaults.standard.string(forKey: "Sex") ?? "Male"
    
    var protein_count: Double {
        if gender == "Male" {
            return 0.8 * ( weightFloat / 2.2)
        } else {
            return 0.8 * ( weightFloat / 2.2)
        }
    }
    
    
    var fat_count: Double {
        if gender == "Male" {
            return 0.3 * (66.47 + (6.24 * weightFloat) + (12.7 * heightFloat) - (6.75 * ageFloat))
        } else {
            return 0.3 *  (65.51 + (4.35 * weightFloat) + (4.7 * heightFloat) - (4.7 * ageFloat))
        }
    }
    
    
    var carb_count: Double {
        if gender == "Male" {
            return 0.45 * (66.47 + (6.24 * weightFloat) + (12.7 * heightFloat) - (6.75 * ageFloat))
        } else {
            return 0.45 * (65.51 + (4.35 * weightFloat) + (4.7 * heightFloat) - (4.7 * ageFloat))
        }
    }
    

    @State private var selectedRange: ClosedRange<Int>?
    @State private var numbers = (0..<10)
        .map { _ in Double.random(in: 0...10) }
    @State private var food_protein: Double = 10
    @State private var food_carb: Double = 10
    @State private var food_fat: Double = 10
    
    var macronutrients: [MacroNutrient] {
        return [
            MacroNutrient(name: "Protein", amountg: food_protein, percentage:(food_protein)/protein_count),
            MacroNutrient(name: "Carbohydrates", amountg: food_carb, percentage: food_carb/carb_count),
            MacroNutrient(name: "Fat", amountg: food_fat, percentage: food_fat/fat_count)
        ]
    }
    @State private var selection: MacroNutrient.ID? = nil
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Chart {
                BarMark(
                    x: .value("Macro Category", "Carbs"),
                    y: .value("% DV", macronutrients[1].percentage)
                ).foregroundStyle(.green)
                BarMark(
                    x: .value("Macro Category", "Fats"),
                    y: .value("% DV", macronutrients[2].percentage)
                ).foregroundStyle(.purple)
                BarMark(
                    x: .value("Macro Category", "Protein"),
                    y: .value("% DV", macronutrients[0].percentage)
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
}

struct BreakdownView_Previews: PreviewProvider {
    static var previews: some View {
        BreakdownView()
    }
}
