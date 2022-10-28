//
//  ChooseProfileImageView.swift
//  BlockMe
//
//  Created by Emily Zhang on 10/27/22.
//

import SwiftUI

struct ChooseProfileImageView: View {
  var email: String
  var password: String
  var firstName: String
  var lastName: String
  var phoneNumber: String
  var venmoHandle: String
  @State private var profileImageURL: String = "images/H3A43UxfupQGyiTAApGAdT1ccmB2.jpg"
  
    var body: some View {
      VStack {
        Text("\(firstName) \(lastName)")
        Text(phoneNumber)
        Text(venmoHandle)
        Text(email)
        Text(password)
        
        Button(action: {
          print("CREATING ACCOUNT")
        }) {
          Text("Create Account")
        }
        .buttonStyle(RedButton())
      }
    }
}
