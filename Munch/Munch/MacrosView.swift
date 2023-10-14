//
//  MacrosView.swift
//  Munch
//
//  Created by elizabeth song on 10/14/23.
//

import SwiftUI

struct MacrosView: View {
    
    @State private var showMacrosView: Bool = false;
    
    var body: some View {
        VStack{
            
            Image("LogoWithBg")
                .resizable()
                .frame(width: 150, height: 37.5)
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                .padding(.vertical)
                .padding(.bottom)
            
            
            Text("Loading...")
                .font(.title)
            
            HStack {
                Image("Egg")
                    .resizable()
                    .frame(width: 40, height: 45, alignment: .leading)
                    .padding(.horizontal)
                
                Image("Egg")
                    .resizable()
                    .frame(width: 40, height: 45, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                
                
                Image("Egg")
                    .resizable()
                    .frame(width: 40, height: 45)
                    .aspectRatio(contentMode: .fit)
                    .frame(alignment: Alignment.trailing)
                    .padding(.horizontal)

            }
        }
       
    }
}
    struct MacrosView_Previews: PreviewProvider {
        static var previews: some View {
            MacrosView()
        }
    }

