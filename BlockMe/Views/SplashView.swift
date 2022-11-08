//
//  SplashView.swift
//  BlockMe
//
//  Created by Wen Shan Jiang on 11/4/22.
//

import SwiftUI

struct SplashView: View {
    @State var isActive:Bool = false
    
    var body: some View {
      ZStack {
            if self.isActive {
                WelcomeView()
            } else {
                Color("BlockMe Red").ignoresSafeArea()
                VStack {
                  Image("logo").resizable()
                    .frame(width: 183, height: 183)
                  Text("BLOCKME").font(.semiLarge).foregroundColor(Color.white)
              }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
      SplashView()
    }
}
