//
//  ContentView.swift
//  Munch
//
//  Created by Bryant Park on 9/30/23.


// r: 252 g: 228 b: 217

import SwiftUI
import Combine


    struct ContentView: View {
        
        @State private var showView : Bool = false
        @State private var showImagePicker: Bool = false
        @State private var image: Image? = nil
        @State private var showCamera: Bool = false
        @State private var showImageLoad: Bool = false
        @State private var selectedImage: Image? = nil
        @State private var isShowingPopup = false
        @State private var isImageLoadViewActive = false
        @State private var isShowingImageLoadView = false
        @State private var ageInput: String = ""
        @State private var weightInput: String = ""
        @State private var heightInput: String = ""
        @State private var gender: String = "Male"
        
        @State private var action: Int? = 0
         
        
        var body: some View {
            NavigationView {
                VStack {
                    Spacer ()
                    Image("LogoWithBg")
                        .resizable()
                        .frame(width: 300, height: 75)
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical)
                        .padding(.bottom)
                    Text("Welcome!")
                        .font(.largeTitle)
                        //.foregroundColor(Color(red:0.3686, green:0.4157, blue:0.4980))
                    
                    Button("Upload from Gallery   ") {
                        self.showImagePicker = true
                        self.showView = false
                        action = 1
                        
                        
                        
                    }.padding()
                        .background(Color(red:0.44313725490196076, green:0.6745098039215687, blue:0.6039215686274509 ))
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .sheet(isPresented: self.$showImagePicker) {
                            PhotoCaptureView(showImagePicker: self.$showImagePicker, selectedImage: self.$selectedImage)
                        }
                    
                    
                    
                    
                    Button("Take A Photo               ") {
                        self.showCamera.toggle()
                        //will change this to camera opening
                    }.padding()
                        .background(Color(red: 0.8745098039215686, green: 0.34509803921568627, blue: 0.35294117647058826))
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .sheet(isPresented: self.$showCamera) {
                            CameraView(selectedImage: self.$selectedImage, isShowingPopup: self.$isShowingPopup)
                        }
                        .onReceive(Just(isShowingImageLoadView), perform: { value in
                            if value {
                                NavigationLink("", destination: ImageLoadViewWrapper(isShowingImageLoadView: $isShowingImageLoadView, selectedImage: self.selectedImage), isActive: $isShowingImageLoadView)
                                    .navigationBarBackButtonHidden(true)
                                    .hidden()
                            }
                        })
                    if let selectedImage = self.selectedImage {
                                           NavigationLink(destination: ImageLoadView(selectedImage: selectedImage)) {
                                               
                                               Image("next")
                                                   .resizable()
                                                   .padding(.top)
                                                   .padding(.top)
                                                   .frame(width: 130, height: 90)
                                                   .scaledToFit()
                                               
                                               
                                           }
//                    if let selectedImage = self.selectedImage {
//                        NavigationLink(destination: ImageLoadView(selectedImage: selectedImage), tag: 1, selection: $action) {
//                            EmptyView()
//                        }.navigationBarBackButtonHidden(true)
                        
                        
//                        NavigationLink(destination: ImageLoadView(selectedImage: selectedImage)) {
//                            Image("next")
//                                .resizable()
//                                .padding(.top)
//                                .padding(.top)
//                                .frame(width: 130, height: 90)
//                                .scaledToFit()
//                        }
                    }
                    Spacer()
                HStack {
                    Button(action: {
                        self.showView.toggle()
                    }) {
                        Text("Enter User Details")
                    }
                    .padding()
                    .background(Color(red:0.3686, green:0.4157, blue:0.4980))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                    .sheet(isPresented: self.$showView) {
                        // Your popup content here
                        VStack {
                            Image("Profile")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                            Text("User Details")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
                            TextField("Age (years)", text: $ageInput)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Weight (lbs)", text: $weightInput)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Height (inches)", text: $heightInput)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            HStack {
                                Button("Male") {
                                    self.gender = "Male"
                                    UserDefaults.standard.set("Male", forKey: "Sex")
                                }
                                .padding()
                                .background(gender == "Male" ? Color(red:0.44313725490196076, green:0.6745098039215687, blue:0.6039215686274509 ) : Color(red:0.3686, green:0.4157, blue:0.4980))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                
                                Button("Female") {
                                    self.gender = "Female"
                                    UserDefaults.standard.set("Female", forKey: "Sex")
                                }
                                .padding()
                                .background(gender == "Female" ? Color(red:0.44313725490196076, green:0.6745098039215687, blue:0.6039215686274509 ) : Color(red:0.3686, green:0.4157, blue:0.4980))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            
                            Button("Close") {
                                let weightInput = $weightInput.wrappedValue
                                let ageInput = $ageInput.wrappedValue
                                let heightInput = $heightInput.wrappedValue
                                UserDefaults.standard.set(ageInput, forKey: "Age")
                                UserDefaults.standard.set(weightInput,forKey: "Weight")
                                UserDefaults.standard.set(heightInput, forKey: "Height")
                                self.showView.toggle()
                            }
                            .padding()
                            .background(Color(red: 0.8745098039215686, green: 0.34509803921568627, blue: 0.35294117647058826))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
}
    struct ContentView_Previews: PreviewProvider{
        static var previews: some View {
            ContentView()
        }
    }
    
    extension Color {
        func toHex() -> String? {
            let uic = UIColor(self)
            guard let components = uic.cgColor.components, components.count >= 3 else {
                return nil
            }
            let r = Float(components[0])
            let g = Float(components[1])
            let b = Float(components[2])
            var a = Float(1.0)
            
            if components.count >= 4 {
                a = Float(components[3])
            }
            
            if a != Float(1.0) {
                return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
            } else {
                return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
            }
        }
    }
    

