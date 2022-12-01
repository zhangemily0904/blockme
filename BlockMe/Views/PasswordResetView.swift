//
//  PasswordResetView.swift
//  BlockMe
//
//  Created by Brian Chou on 12/1/22.
//

import SwiftUI

struct PasswordResetView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @State private var email: String = ""
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
        
        Text("Reset Your Password").font(.medLarge)
        TextField("Email", text: $email)
          .textFieldStyle(InputField())
        
        Button(action: {
          guard !email.isEmpty else {
            alertMsg = "Email cannot be empty."
            showErrorAlert = true
            return
          }
//          appViewModel.signIn(email: email, password: password) { error in
//            if let error = error {
//              alertMsg = error.localizedDescription
//              showErrorAlert = true
//            }
//          }
        }) {
          Text("Send Recovery Email").font(.medSmall)
        }.buttonStyle(RedButton()).padding(.top, 70)
      }
      .alert(alertMsg, isPresented: $showErrorAlert) {
        Button("Ok", role: .cancel) {
          showErrorAlert = false
        }
      }

    }
  }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
