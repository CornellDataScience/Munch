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
    @State private var isLoading: Bool = false
    @State private var beforeContinue: Bool = true
    @State private var triggerError: Bool = false
    @State private var afterContinue: Bool = false
    @State private var buttonShow: Bool = true
    

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>


    var body: some View {
        NavigationView {

            VStack{
                
                //view #1: before continuing, has image and continue button
                if beforeContinue {
                    
                    Image("LogoWithBg")
                        .resizable()
                        .frame(width: 300, height: 75)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical)
                    
                    
                    
                    Text("Your Image:")
                        .font(.headline)
                    
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom)
                        .padding()
                }
                
                //view #2: has view of charts
                if afterContinue {
                    BreakdownView()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
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
                    
                
              /* NavigationLink(destination: MacrosView()) {
                
                    Button("CONTINUE") {}
                        .padding()
                        .background(Color(red: 0.8745098039215686, green: 0.34509803921568627, blue: 0.35294117647058826))
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .frame(width: 130, height: 90)
                        .scaledToFit()
                    
                } */
                Spacer()
                
            }
            }
        }
    
}
struct ImageLoadView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoadView(selectedImage: Image("Logo"))
    }
}
