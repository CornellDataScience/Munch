//
//  Camera.swift
//  Munch
//
//  Created by elizabeth song on 10/14/23.
//

import SwiftUI


struct Camera: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

