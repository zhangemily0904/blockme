//
//  ChooseProfileImageView.swift
//  BlockMe
//
//  Created by Emily Zhang on 10/27/22.
//

import SwiftUI
import PhotosUI

struct ChooseProfileImageView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  var email: String
  var password: String
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var venmoHandle: String
  @State private var showSheet = false
  @State private var showErrorAlert = false
  @State private var error: String = ""
  @State private var pickerResult: [UIImage] = []
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        
        VStack {
          Group {
            Text("Hello \(firstName)").font(.medLarge).padding(.top, 20).padding(.bottom, 5)
            Text("You are almost there. Upload a profile photo").font(.regMed).frame(maxWidth: 352)}.frame(alignment: .top)
          
          Spacer()
          
          Image(uiImage: self.pickerResult.first ?? UIImage())
              .resizable()
              .frame(width: 200, height: 200)
              .background(Color.black.opacity(0.2))
              .aspectRatio(contentMode: .fill)
              .clipShape(Circle())
          
          Button(action: {
            showSheet = true
          }) {
            Text("Choose Image")
          }
          
          Spacer()
          
          Button(action: {
            guard let image = self.pickerResult.first else {
              error = "No profile image selected."
              showErrorAlert = true
              return
            }
            
            appViewModel.signUp(email: email, password: password, firstName: firstName, lastName: lastName, venmoHandle: venmoHandle, phoneNumber: phoneNumber, profileImage: image) { errorMsg in
              if let errorMsg = errorMsg {
                error = errorMsg
                showErrorAlert = true
              }
            }
          }) {
            Text("Create Account")
          }
          .buttonStyle(RedButton())
          
          Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showSheet) {
                PhotoPicker(pickerResult: $pickerResult,
                            isPresented: $showSheet)
              }
        .alert(error, isPresented: $showErrorAlert) {
          Button("Ok", role: .cancel) {
            showErrorAlert = false
          }
        }
      }
      
    }
}
