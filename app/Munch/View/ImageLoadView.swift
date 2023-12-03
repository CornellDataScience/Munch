//
//  ImageLoadView.swift
//  Munch
//
//  Created by elizabeth song on 10/18/23.
//

import SwiftUI

struct ImageLoadViewWrapper: UIViewControllerRepresentable {
    @Binding var isShowingImageLoadView: Bool
    var selectedImage: Image?

    func makeUIViewController(context: Context) -> UIViewController {
        guard isShowingImageLoadView, let selectedImage = selectedImage else {
            return UIViewController()
        }
        let imageLoadView = ImageLoadView(selectedImage: selectedImage)
        return UIHostingController(rootView: imageLoadView)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
}


struct ImageLoadView: View {
    
    var selectedImage: Image
    @StateObject private var viewModel = ImageLoadVM()
    @State private var isLoading: Bool = false
    @State private var triggerError: Bool = false
    @State private var buttonShow: Bool = false
    @State private var isPosted: Bool = false
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        NavigationView {
            
            VStack{
                //view #1: before continuing, has image and continue button
                Image("LogoWithBg") // dummy image
                    .resizable()
                    .frame(width: 300, height: 75)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical)
                Text("Your Image:")
                    .font(.title)
                selectedImage
                    .resizable()
                    .cornerRadius(25.0)
                    .scaledToFit()
                    .padding(.bottom)
                    .padding()
                HStack{
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                                 Text("BACK")
                                     .padding()
                                     .background(Color(red:0.3686, green:0.4157, blue:0.4980))
                                     .foregroundColor(Color.white)
                                     .cornerRadius(10)
                                     .frame(alignment: .leading)
                             }
                                 
        
                
                    if (viewModel.isReady) {
                        NavigationLink(destination: MacrosView(food_id: viewModel.food_id).navigationBarBackButtonHidden(true)) {
                            Text("CONTINUE")
                                .padding()
                                .background(Color(red: 0.8745098039215686, green: 0.34509803921568627, blue: 0.35294117647058826))
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                        }
                    }
            
                }
                Spacer()
                
            }.onAppear(perform: {() in viewModel.postImage(img: selectedImage)
            })
        }
    }
    
    
    struct ImageLoadView_Previews: PreviewProvider {
        static var previews: some View {
            ImageLoadView(selectedImage: Image("Logo"))
        }
    }
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct ImageLoadView_Previews: PreviewProvider {
      static var previews: some View {
          ImageLoadView(selectedImage: Image("AppIcon"))
      }
  }
