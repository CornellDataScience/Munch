//
//  CameraView.swift
//  Munch
//
//  Created by elizabeth song on 10/14/23.
//live photo capture

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
       
       @Binding var selectedImage: Image?
       @Binding var isShowingPopup: Bool
       @State private var isShowingImageLoadView = false

    
       func makeCoordinator() -> Coordinator {
           return Coordinator(selectedImage: $selectedImage, isShowingPopup: $isShowingPopup)
       }
       
       func makeUIViewController(context: Context) -> ViewController {
           let viewController = ViewController()
           viewController.coordinator = context.coordinator
           return viewController
       }
       
       func updateUIViewController(_ uiViewController: ViewController, context: Context) {
           // Update the view controller if needed
       }
       
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
            @Binding var selectedImage: Image?
            @Binding var isShowingPopup: Bool
            
            init(selectedImage: Binding<Image?>, isShowingPopup: Binding<Bool>) {
                _selectedImage = selectedImage
                _isShowingPopup = isShowingPopup

            }
            
            func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
                guard let data = photo.fileDataRepresentation(),
                    let image = UIImage(data: data) else {
                        return
                }
                
                DispatchQueue.main.async {
                    // Update the @Binding variable with the captured image
                    self.selectedImage = Image(uiImage: image)
                    self.isShowingPopup = false

                }
                
              
            }
        func didCaptureImage(_ image: UIImage?) {
               // Handle the captured image if needed
           }
        }
    /*
    typealias UIViewControllerType = ViewController
    
    var onCapture: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.captureImage = { image in
                   // Call the closure when an image is captured
                   self.onCapture(image)
               }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update the view controller if needed
    }
    //insert function here about loading image...
    */
    
}

/*struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView{capturedImage in
            // Handle the captured image (for preview, use a placeholder image)
            if let capturedImage = capturedImage {
                // Handle capturedImage if needed (e.g., display it using Image(uiImage: capturedImage))
            }
        }    }
}*/
