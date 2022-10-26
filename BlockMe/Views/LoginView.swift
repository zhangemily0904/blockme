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
      NavigationView {
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
            SecureField("Password", text: $password)
              .textFieldStyle(RoundedBorderTextFieldStyle())
                              .padding()
                              .autocapitalization(.none)
                              .disableAutocorrection(true)
            
            // should make this button a reusable component
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
              NavigationLink("Not a member? Register now", destination: CreateAccountView())
            }.frame(maxHeight: .infinity, alignment: .bottom)
            
          }
        }
      }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
