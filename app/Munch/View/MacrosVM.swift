//
//  LoadingVM.swift
//  Munch
//
//  Created by Koji Kimura on 10/29/23.
//

import Foundation

final class MacrosVM: ObservableObject {
    @Published var food_name: String = ""
    @Published var isReady: Bool = false
    
    func runModel(food_id: String) {
        APIServices.shared.runModel(food_id: food_id, onSuccess: {(food_name) in
            self.food_name = food_name.name
            self.isReady = true
        })
    }
}
 
