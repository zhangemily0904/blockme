//
//  CreateAccountView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import SwiftUI

struct CreateAccountView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @State private var firstName: String = ""
  @State private var lastName: String = ""
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var venmoHandle: String = ""
  @State private var phoneNumber: String = ""
  
  @ViewBuilder
  var body: some View {
      NavigationView{
        ZStack{
          Color("BlockMe Background").ignoresSafeArea()
          VStack{
            Text("Sign Up").font(.title)
            Text("Create an account. It's free")
            TextField("First Name", text: $firstName)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding()
              .autocapitalization(.none)
              .disableAutocorrection(true)
            TextField("Last Name", text: $lastName)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding()
              .autocapitalization(.none)
              .disableAutocorrection(true)
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
            TextField("Venmo Handle", text: $venmoHandle)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding()
              .autocapitalization(.none)
              .disableAutocorrection(true)
            TextField("Phone Number", text: $phoneNumber)
              .textFieldStyle(RoundedBorderTextFieldStyle())
              .padding()
              .autocapitalization(.none)
              .disableAutocorrection(true)
            
            NavigationLink(destination: ChooseProfileImageView(email: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, venmoHandle: venmoHandle)) {
              Text("Continue")
                .bold()
                .frame(width: 200, height: 40)
                .foregroundColor(Color.white)
                .background(
                  RoundedRectangle(cornerRadius: 10, style: .continuous).fill(validateFields() ? Color("BlockMe Red") : Color.gray)
                )
            }.disabled(!validateFields())
          }
        }
        }
      }
    
  func validateFields() -> Bool {
      guard !firstName.isEmpty && !lastName.isEmpty && !venmoHandle.isEmpty && !phoneNumber.isEmpty else {
        return false
      }
      return appViewModel.validateFields(email: email, number: phoneNumber)
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
