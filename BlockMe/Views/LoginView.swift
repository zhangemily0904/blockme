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
  @State private var showErrorAlert = false
  @State private var alertMsg = ""

    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        
        VStack {
          Group {
            Image("welcome")
              .resizable()
              .frame(width: 201.0, height: 250.0)
          }
          
          Text("Hello Again!").font(.medLarge)
          TextField("Email", text: $email)
            .textFieldStyle(InputField())
          SecureField("Password", text: $password)
            .textFieldStyle(InputField())
          
          // TODO: password recovery
          Text("Forgot Password?").font(.regSmall).frame(width: 352, alignment: .trailing)
          
         
          Button(action: {
            guard !email.isEmpty && !password.isEmpty else {
              alertMsg = "Email or password cannot be empty."
              showErrorAlert = true
              return
            }
            appViewModel.signIn(email: email, password: password) { error in
              if let error = error {
                alertMsg = error.localizedDescription
                showErrorAlert = true
              }
            }
          }) {
            Text("Log In").font(.medSmall)
          }.buttonStyle(RedButton()).padding(.top, 70)
          
          Group{
            NavigationLink("Not a member? Register now", destination: CreateAccountView()).font(.regSmall).foregroundColor(Color.black)
          }.frame(maxHeight: .infinity, alignment: .bottom)
          
        }
        .alert(alertMsg, isPresented: $showErrorAlert) {
          Button("Ok", role: .cancel) {
            showErrorAlert = false
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
