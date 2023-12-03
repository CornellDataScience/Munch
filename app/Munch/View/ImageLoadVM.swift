//
//  ImageLoadVM.swift
//  Munch
//
//  Created by Koji Kimura on 10/29/23.
//

import Foundation
import SwiftUI

final class ImageLoadVM: ObservableObject {
    @Published var food_id: String = ""
    @Published var isReady: Bool = false
    
    func postImage(img: Image) {
        APIServices.shared.postImage(image: img, onSuccess: {(food_id) in
            self.food_id = food_id.file_id
            self.isReady = true
        })
    }
}
 
