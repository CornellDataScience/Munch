//
//  MacrosView.swift
//  Munch
//
//  Created by elizabeth song on 10/14/23.
//

import SwiftUI

struct MacrosView: View {
    let food_id: String
    
    @StateObject private var viewModel = MacrosVM()
    @State private var isBouncing = false
    @State private var isReady = false
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
                if (viewModel.isReady){
                    NavigationLink(destination: NutrientsView(food: viewModel.food_name).navigationBarBackButtonHidden(true)) {
                        Text("CONTINUE")
                            .padding()
                            .background(Color(red: 0.8745098039215686, green: 0.34509803921568627, blue: 0.35294117647058826))
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }
                }
            }.onLoad(perform: {() in viewModel.runModel(food_id: food_id)
            })
            
        }
      
       
    }
}
    struct MacrosView_Previews: PreviewProvider {
        static var previews: some View {
            MacrosView(food_id: "6655f517-4cbd-428f-a057-4878dc89ace9")
        }
    }

