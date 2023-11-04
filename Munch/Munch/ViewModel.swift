//
//  ViewModel.swift
//  Munch
//
//  Created by elizabeth song on 10/28/23.
//

import Foundation
import SwiftUI

struct Food: Hashable, Codable {
    let name : String
    let carbs : Float32
    let protein: Float32
    let fats : Float32
}

class ViewModel: ObservableObject {
    @Published var foods: [Food] = []
    
    func fetch () {
        guard let url = URL(string:"url") else {return}
        
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let foods = try JSONDecoder().decode([Food].self, from:data)
                DispatchQueue.main.async{
                    self.foods = foods
                }
            }
            catch {
                print(error)
            }
            
        }
        task.resume()
        
        
    }
}
