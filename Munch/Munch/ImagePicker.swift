//
//  ImagePicker.swift
//  Munch
//
//  Created by elizabeth song on 10/6/23.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    @State private var foodName: String = ""
    @State private var fileID: String = ""
    
    
    init(isShown:Binding<Bool>, image: Binding<UIImage?>){
        _isShown = isShown
        _image = image
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = uiImage
        isShown = false
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
        
    }
    
}
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var image: UIImage?
    
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}

