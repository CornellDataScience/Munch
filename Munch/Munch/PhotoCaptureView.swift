//
//  PhotoCaptureView.swift
//  Munch
//
//  Created by elizabeth song on 10/6/23.
// you can choose images from gallery

import SwiftUI

struct PhotoCaptureView: View {
   
    @Binding var showImagePicker: Bool
    @Binding var selectedImage: Image?

    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $selectedImage)
            .onChange(of: selectedImage) { newImage in
                if let image = newImage {
                    self.selectedImage = image
                    self.showImagePicker = false // Dismiss the image picker after selecting an image
                }
            }
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), selectedImage: .constant(Image("")))
    }
}
