//
//  SelectedImageView.swift
//  Munch
//
//  Created by elizabeth song on 10/19/23.
//
// SelectedImageView.swift

import SwiftUI

struct SelectedImageView: View {
    var selectedImage: Image

    var body: some View {
        VStack {
            selectedImage
                .resizable()
                .scaledToFit()
                .padding()

            // You can add more UI components or modify the layout as needed
        }
    }
}
