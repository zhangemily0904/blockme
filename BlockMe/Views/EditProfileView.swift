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
  @State private var venmoHandle = ""
  @State private var phoneNumber = ""
  
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
                // somehow user isn't loaded
                return
              }
              
              let newUser = User(firstName: user.firstName, lastName: user.lastName, venmoHandle: venmoHandle, phoneNumber: phoneNumber, profileImageURL: user.profileImageURL)
              guard userViewModel.update(user: newUser) else {
                print("error updating user")
                return
              }
              presentationMode.wrappedValue.dismiss()
            }) {
              Text("Update")
            }.buttonStyle(RedButton())
          }.frame(maxHeight: .infinity, alignment: .bottom)
        }
      }
      
    }
}
