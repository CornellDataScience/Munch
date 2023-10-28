//
//  MacrosView.swift
//  Munch
//
//  Created by elizabeth song on 10/14/23.
//

import SwiftUI

struct MacrosView: View {
    
    @State private var isBouncing = false
    
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
                    .padding(.bottom)
                    
                HStack {
                    Group {
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
                            .scaleEffect(isBouncing ? 1.2 : 1.0)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                    isBouncing.toggle()
                                }
                            }
                        
                        Image("Egg")
                            .resizable()
                            .frame(width: 40, height: 45, alignment: .center)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(isBouncing ? 1.2 : 1.0)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                    isBouncing.toggle()
                                }
                            }
                        
                        Image("Sandwich")
                            .resizable()
                            .frame(width: 40, height: 45)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .padding(.bottom)
                            .aspectRatio(contentMode: .fit)
                            .frame(alignment: Alignment.trailing)
                            .scaleEffect(isBouncing ? 1.2 : 1.0)
                            .onAppear() {
                                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                    isBouncing.toggle()
                                }
                            }
                    }
                }
//
//
//
//                }
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

