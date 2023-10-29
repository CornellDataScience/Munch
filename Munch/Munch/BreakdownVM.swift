//
//  BreakdownViewModel.swift
//  Munch
//
//  Created by Koji Kimura on 10/28/23.
//

import Foundation


final class BreakdownVM: ObservableObject {
    @Published var nutrients: Nutrients = MockNutrients.mockNutrients
    
    init() { }
    
    func loadNutrients() {
        APIServices.shared.loadNutrients(){(nutrientsResponse) in
            self.nutrients = nutrientsResponse
        }
    }
}
 
