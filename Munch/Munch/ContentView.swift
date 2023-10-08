//
//  ContentView.swift
//  Munch
//
//  Created by Bryant Park on 9/30/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showImagePicker: Bool = false
    @State private var image: Image? = nil
    
    var body: some View {
        VStack{
            Image("LogoWithBg")
                .resizable()
                .frame(width: 300, height: 75)
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .padding(.vertical)
                .padding(.bottom)
            Text("Welcome!")
                .font(.largeTitle)
            
            
            image?.resizable()
                .scaledToFit()
        
            Button("Upload from") {
                self.showImagePicker = true
                
            }.padding()
                .background(Color(red:0.44313725490196076, green:0.6745098039215687, blue:0.6039215686274509 ))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            
            Button("Take A Photo     ") {
                self.showImagePicker = true
                //will change this to camera opening
                
            }.padding()
                .background(Color(red: 0.8745098039215686, green: 0.34509803921568627, blue: 0.35294117647058826))
                .foregroundColor(Color.white)
                .cornerRadius(10)
            
        }.sheet(isPresented: self.$showImagePicker) {
            PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image)
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


