//
//  AnimationView.swift
//  Munch
//
//  Created by Anya on 10/29/23.
//

import SwiftUI

struct AnimationView: View {
    @State private var isBouncing = false
    
    var body: some View {
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
    }
}
