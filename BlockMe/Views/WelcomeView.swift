//
//  WelcomeView.swift
//  BlockMe
//
//  Created by Wen Shan Jiang on 11/8/22.
//

import SwiftUI

struct WelcomeView: View {
    
  var body: some View {
    ZStack{
      Color("BlockMe Background").ignoresSafeArea()
      VStack {
        Group {
          Image("intro")
            .resizable()
            .frame(width: 300.0, height: 247.0)
        }
        Text("Hey! Welcome").font(.medLarge).padding(.top, 50).padding(.bottom, 10)
        Text("BlockMe is a free meal blocks marketplace, log in or register to get started!").font(.regMed).frame(width: 350.0).multilineTextAlignment(.center).padding(.bottom, 70)
        NavigationLink(destination: CreateAccountView()) {
                            Text("Register").font(.medSmall)
            .bold()
            .frame(width: 352, height: 57)
            .foregroundColor(Color.white)
            .background(
              RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color("BlockMe Red"))
            )
        }.padding(.bottom, 15)
          NavigationLink("Joined us before? Login", destination: LoginView()).font(.regSmall).foregroundColor(Color.black)
      }
    }
  }
    
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
      WelcomeView()
    }
}
