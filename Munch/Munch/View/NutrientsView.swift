//
//  NutrientsView.swift
//  Munch
//
//  Created by Koji Kimura on 10/29/23.
//
import SwiftUI
import Charts


struct NutrientsView: View {
    let food: String
    
    @StateObject private var viewModel = NutrientsVM()
    
    var body: some View {
        VStack{
            Text(food.replacingOccurrences(of: "%20", with: " "))
            if #available(iOS 16.0, *) {
                Chart {
                    BarMark(
                        x: .value("Macro Category", "Carbs"),
                        y: .value("% DV", viewModel.nutrients.carbs/3.0)
                    ).foregroundStyle(.green)
                    BarMark(
                        x: .value("Macro Category", "Fats"),
                        y: .value("% DV", viewModel.nutrients.fats/65*100)
                    ).foregroundStyle(.purple)
                    BarMark(
                        x: .value("Macro Category", "Protein"),
                        y: .value("% DV", viewModel.nutrients.protein*2)
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
                        
                    }.onLoad(perform:
                                { () in
                        viewModel.loadNutrients(food: food)
                    })
            } else {
                Text("Charts only available in iOS 16.0+")
            }
        }
    }
}

struct NutrientsView_Previews: PreviewProvider {
    static var previews: some View {
        NutrientsView(food: "Churros")
    }
}
