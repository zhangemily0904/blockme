//
//  ChooseProfileImageView.swift
//  BlockMe
//
//  Created by Emily Zhang on 10/27/22.
//

import SwiftUI
import PhotosUI

struct ChooseProfileImageView: View {
  var email: String
  var password: String
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var venmoHandle: String
  @State private var showSheet = false
  @State var pickerResult: [UIImage] = []
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        
        VStack {
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
          
          Button(action: {}) {
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
      }
      
    }
}
