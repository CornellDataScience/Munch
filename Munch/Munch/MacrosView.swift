//
//  MacrosView.swift
//  Munch
//
//  Created by elizabeth song on 10/14/23.
//

import SwiftUI

struct MacrosView: View {

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
                    .padding(.bottom)
                
                
            AnimationView()
                    .frame(width: 300, height: 300, alignment: .center)
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

