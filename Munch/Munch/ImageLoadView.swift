//
//  ImageLoadView.swift
//  Munch
//
//  Created by elizabeth song on 10/18/23.
//

import SwiftUI

struct ImageLoadViewWrapper: UIViewControllerRepresentable {
    @Binding var isShowingImageLoadView: Bool
    var selectedImage: UIImage?

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
    var selectedImage: UIImage
    @State private var isLoading: Bool = false
    @State private var beforeContinue: Bool = true
    @State private var triggerError: Bool = false
    @State private var afterContinue: Bool = false
    @State private var buttonShow: Bool = true
    
    
    
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    private func uploadImageOne() {
        let image: UIImage = selectedImage // Create an Image anyhow you want
        guard let imageData = image.pngData() else {
               // Handle the case when selectedImage is nil or cannot be converted to UIImage
               return
           }
           
           var request = URLRequest(url: URL(string: "our url request")!)
           request.httpMethod = "POST"
           
           let boundary = "Boundary-\(UUID().uuidString)"
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
           
           var body = Data()
           
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n".data(using: .utf8)!)
           body.append("Hello World\r\n".data(using: .utf8)!)
           
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\r\n".data(using: .utf8)!)
           body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
           body.append(imageData)
           body.append("\r\n".data(using: .utf8)!)
           body.append("--\(boundary)--\r\n".data(using: .utf8)!)
           
           request.httpBody = body
           
           URLSession.shared.dataTask(with: request) { data, response, error in
               // Handle the response from the server
               if let error = error {
                   print("Error: \(error)")
               } else if let data = data {
                   // Process the response data if needed
                   print("Response: \(String(data: data, encoding: .utf8) ?? "")")
               }
           }.resume()
       }

    
    var body: some View {
        NavigationView {
            
            VStack{
                
                // using conditioned toggle logic instead of nagivation links between screens
                
                if beforeContinue {
                                    
                    Image("LogoWithBg")
                        .resizable()
                        .frame(width: 300, height: 75)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical)
                    
                    
                    
                    Text("Your Image:")
                        .font(.headline)
                    
                    let selectedImageImage = Image(uiImage: selectedImage)
                    
                    selectedImageImage
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .padding(.bottom)
                }
                
                //view #2: has view of charts
                if afterContinue {
                    BreakdownView()
                        .frame(width: 300, height: 300, alignment: .center)
                    Button(action: {                     self.presentationMode.wrappedValue.dismiss()

                    }) {
                        Text("RETURN HOME")
                            .padding()
                            .background(Color(red:0.44313725490196076, green:0.6745098039215687, blue:0.6039215686274509 ))
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                }
                 
                if isLoading {
                    MacrosView()
                        .edgesIgnoringSafeArea(.all)
                } else if buttonShow {
                                Button(action: {
                                    isLoading.toggle()
                                    beforeContinue = false
                                    afterContinue = false
                                    // Simulate loading delay with DispatchQueue
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                        isLoading = false
                                        afterContinue = true
                                        buttonShow = false
                                    }
                                }) {
                                    Text("CONTINUE")
                                        .padding()
                                        .background(Color(red: 0.8745098039215686, green: 0.34509803921568627, blue: 0.35294117647058826))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(10)
                                }
                            } else {
                                
                            }
                Spacer()
                
            }
        }
    }
    
    
   // struct ImageLoadView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        ImageLoadView(selectedImage: UIImage("Logo"))
    //    }
  //  }
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
