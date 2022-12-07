//
//  EditProfileView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/2/22.
//

import SwiftUI

struct EditProfileView: View {
  @Environment(\.presentationMode) private var presentationMode // used so we can use update button to backward navigate
  @ObservedObject var listingRepository = ListingRepository()
  @EnvironmentObject var appViewModel: AppViewModel
  @Environment(\.dismiss) var dismiss
  @State private var showErrorAlert = false
  @State private var venmoHandle = ""
  @State private var phoneNumber = ""
  @State private var alertMsg = ""
  
  var body: some View {
    ZStack {
      VStack {
        Text("Update Your Information").font(.medMed).frame(width: 352)
          .padding(.bottom, 30)
        
        if let userViewModel = appViewModel.userViewModel {
          VStack {
            Text("Venmo Handle").font(.medSmall).frame(width: 352, alignment: .leading)
            TextField(userViewModel.user?.venmoHandle ?? "Venmo Handle", text: $venmoHandle)
              .textFieldStyle(InputField())
              .padding(.bottom, 20)
            Text("Phone Number").font(.medSmall).frame(width: 352, alignment: .leading)
            TextField(userViewModel.user?.phoneNumber ?? "Phone Number", text: $phoneNumber)
              .textFieldStyle(InputField())
              .padding(.bottom, 40)
          }.frame(width: 352, alignment: .leading)
          
          Button(action: {
            guard let user = userViewModel.user else {
              return
            }
            guard FormValidator.isValidPhoneNumber(number: phoneNumber) && !venmoHandle.isEmpty else {
              alertMsg = "Venmo handle cannot be empty and phone number must be 10 digits long."
              showErrorAlert = true
              return
            }
            
            let newUser = User(firstName: user.firstName, lastName: user.lastName, venmoHandle: venmoHandle, phoneNumber: phoneNumber, profileImageURL: user.profileImageURL, ratings: user.ratings)
            guard userViewModel.update(user: newUser) else {
              alertMsg = "There was an error updating your information. Please try again later."
              showErrorAlert = true
              return
            }
            
            DispatchQueue.main.async {
              _ = listingRepository.updateCurrentListingWithNewUserInfo(uid: userViewModel.id, venmoHandle: venmoHandle, phoneNumber: phoneNumber)
            }
            presentationMode.wrappedValue.dismiss()
          }) {
            Text("Update").font(.medSmall)
          }.buttonStyle(RedButton())
          
          Button(action: {dismiss()}) {
            Text("Cancel")
          }.buttonStyle(WhiteButton())
            .font(.medSmall)
        }
      }
      .onAppear {
        guard let userViewModel = appViewModel.userViewModel else {
          alertMsg = "Error loading user information. Please try again later."
          showErrorAlert = true
          return
        }
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
