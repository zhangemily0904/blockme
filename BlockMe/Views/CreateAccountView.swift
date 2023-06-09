//
//  CreateAccountView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//
import SwiftUI
import iPhoneNumberField

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
      ZStack{
        Color("BlockMe Background").ignoresSafeArea()
        VStack{
          Text("Sign Up").font(.medLarge).padding(.top, 20).padding(.bottom, 5)
          Text("Create an account. It's free").font(.regMed).padding(.bottom, 10)
          TextField("First Name", text: $firstName)
            .textFieldStyle(CapitalizationInputField())
          TextField("Last Name", text: $lastName)
            .textFieldStyle(CapitalizationInputField())
          TextField("Email", text: $email)
            .textFieldStyle(InputField())
          SecureField("Password", text: $password)
            .textFieldStyle(InputField())
          iPhoneNumberField("Phone Number", text: $phoneNumber)
            .flagHidden(false)
            .flagSelectable(true)
            .padding()
            .frame(width: 352, height: 64)
            .overlay {
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black, lineWidth: 2)
            }
          TextField("Venmo Handle", value: $venmoHandle, formatter: VenmoFormatter())
            .textFieldStyle(InputField())
          
          NavigationLink(destination: ChooseProfileImageView(email: email, password: password, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, venmoHandle: "@\(venmoHandle)")) {
            Text("Continue").font(.medSmall)
              .frame(width: 352, height: 57)
              .foregroundColor(Color.white)
              .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(validateFields() ? Color("BlockMe Red") : Color.gray)
              )
              .padding(.top, 30)
          }.disabled(!validateFields())
          
          Group{
            NavigationLink("Join us before? Login", destination: LoginView()).font(.regSmall).foregroundColor(Color.black)
          }.frame(maxHeight: .infinity, alignment: .bottom)
        }
      }.onTapGesture {
        self.hideKeyboard()
      }
    }
    
  func validateFields() -> Bool {
      guard !firstName.isEmpty && !lastName.isEmpty && !venmoHandle.isEmpty && !phoneNumber.isEmpty else {
        return false
      }
    return FormValidator.validateFields(email: email, number: phoneNumber)
    }
}

struct CreateAccountView_Previews: PreviewProvider {
  static var previews: some View {
    CreateAccountView()
  }
}
