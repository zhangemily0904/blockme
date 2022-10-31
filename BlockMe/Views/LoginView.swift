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
  @State private var errorMsg: String? = nil
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
          SecureField("Password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
          
          if let msg = errorMsg {
            Text(msg).foregroundColor(Color.red)
          }
         
          Button(action: {
            guard !email.isEmpty && !password.isEmpty else {
              return
            }
            appViewModel.signIn(email: email, password: password) { error in
              if let error = error {
                errorMsg = error.localizedDescription
              }
            }
          }) {
            Text("Log In")
          }.buttonStyle(RedButton())
          
          Group{
            NavigationLink("Not a member? Register now", destination: CreateAccountView())
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
