//
//  LoginView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import SwiftUI

struct LoginView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @State private var email: String = ""
  @State private var password: String = ""
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        
        VStack {
          Group {
            Text("Image goes here").font(.title)
          }.frame(maxHeight: .infinity, alignment: .top)
          
          Text("Hello Again!").font(.title)
          TextField("Email", text: $email)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
          TextField("Password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
          
          Button(action: {
            guard !email.isEmpty && !password.isEmpty else {
              return
            }
            appViewModel.signIn(email: email, password: password)
          }) {
            Text("Log In")
              .bold()
              .frame(width: 200, height: 40)
              .foregroundColor(Color.white)
              .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("BlockMe Red"))
              )
          }
          
          Group{
            // should make this button a reusable component
            Button(action: {}) {
              Text("Not a member? Register now")
                .foregroundColor(Color.black)
            }
          }.frame(maxHeight: .infinity, alignment: .bottom)
          
        }
      }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
