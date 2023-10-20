//
//  MacrosView.swift
//  Munch
//
//  Created by elizabeth song on 10/14/23.
//

import SwiftUI

struct MacrosView: View {
    
  //  @State private var showMacrosView: Bool = false;

    var body: some View {
        ZStack(alignment: .center) {

            VStack{
                
                Image("LogoWithBg")
                    .resizable()
                    .frame(width: 150, height: 37.5)
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top)
                    .padding(.top)
                    .padding(.top)
                    .padding(.top)
                    .padding(.top)
                    .padding(.vertical)
                
                Spacer()

                Text("Loading...")
                    .font(.title)
                    .padding(.bottom)
                    .padding(.bottom)
                

                HStack {
                    Image("Apple")
                        .resizable()
                        .frame(width: 40, height: 45, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                    .padding(.bottom)
                    .padding(.bottom)
                    .padding(.bottom)
                    .padding(.bottom)
                        .padding(.bottom)
                    
                    Image("Egg")
                        .resizable()
                        .frame(width: 40, height: 45, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)

                    
                    
                    Image("Sandwich")
                        .resizable()
                        .frame(width: 40, height: 45)
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: Alignment.trailing)
                        .padding(.horizontal)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)
                        .padding(.bottom)                    .padding(.bottom)



                }
                Spacer()

            }
            
        }
      
       
    }
}
    struct MacrosView_Previews: PreviewProvider {
        static var previews: some View {
            MacrosView()
        }
    }

