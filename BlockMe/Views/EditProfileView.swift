//
//  EditProfileView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/2/22.
//

import SwiftUI

struct EditProfileView: View {
  @Environment(\.presentationMode) private var presentationMode // used so we can use update button to backward navigate
  @EnvironmentObject var appViewModel: AppViewModel
  @ObservedObject var userViewModel: UserViewModel
  @State private var showErrorAlert = false
  @State private var venmoHandle = ""
  @State private var phoneNumber = ""
  @State private var alertMsg = ""
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        
        VStack {
          Group {
            Text("Update Your Information").font(.title)
          }.frame(maxHeight: .infinity, alignment: .top)
          
          Text("Venmo Handle")
          TextField(userViewModel.user?.venmoHandle ?? "Venmo Handle", text: $venmoHandle)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(true)
          Text("Phone Number")
          TextField(userViewModel.user?.phoneNumber ?? "Phone Number", text: $phoneNumber)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(true)
          
          Group{
            Button(action: {
              guard let user = userViewModel.user else {
                return
              }
              guard FormValidator.validatePhoneNumber(number: phoneNumber) && !venmoHandle.isEmpty else {
                alertMsg = "Venmo handle cannot be empty and phone number must be 10 digits long."
                showErrorAlert = true
                return
              }
              
              let newUser = User(firstName: user.firstName, lastName: user.lastName, venmoHandle: venmoHandle, phoneNumber: phoneNumber, profileImageURL: user.profileImageURL)
              guard userViewModel.update(user: newUser) else {
                alertMsg = "There was an error updating your information. Please try again later."
                showErrorAlert = true
                return
              }
              presentationMode.wrappedValue.dismiss()
            }) {
              Text("Update")
            }.buttonStyle(RedButton())
          }.frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
          venmoHandle = userViewModel.user?.venmoHandle ?? ""
          phoneNumber = userViewModel.user?.phoneNumber ?? ""
        }
        .alert(alertMsg, isPresented: $showErrorAlert) {
          Button("Ok", role: .cancel) {
            showErrorAlert = false
          }
        }
      }
      
    }
}
