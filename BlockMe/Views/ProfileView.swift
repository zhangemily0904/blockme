//
//  ProfileView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct ProfileView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  
  var body: some View {
    ZStack {
      Color("BlockMe Background").ignoresSafeArea()
      VStack {
        ZStack {
          Image("profile").resizable().scaledToFit().offset(y: -150)
          if let userViewModel = appViewModel.userViewModel {
            if let profileImage = userViewModel.profileImage {
              Image(uiImage: profileImage)
                .resizable()
                .frame(width: 160, height: 160)
                .clipShape(Circle())
                .offset(y: -50)
            }
          }
        }
        if let userViewModel = appViewModel.userViewModel {
          if let user = userViewModel.user {
            Text("\(user.firstName) \(user.lastName)").font(.medMed)
              .offset(y: -60)
          }
          HStack {
            VStack {
              NavigationLink("Manage Account", destination: EditProfileView())
              Text("Update your information").font(.medTiny).foregroundColor(.gray).offset(x: 5)
            }.frame(width: 300, alignment: .leading)
              .padding(.leading, 15)
            Image("next")
              .resizable()
              .frame(width: 20, height: 20, alignment: .trailing)
              .padding(.trailing, 15)
          }
            .frame(width: 353, height: 75)
            .background(Color("BlockMe Yellow").clipShape(RoundedRectangle(cornerRadius:15)))
            .font(.medSmall)
            .foregroundColor(.black)
            .offset(y: -20)
        }
        
        HStack {
          Button(action: {
//            appViewModel.signOut()
            print("click")
          }) {
            Text("Sign Out").font(.medSmall).frame(width: 295, alignment: .leading)
              .padding(.leading, 70)
            Image("next")
              .resizable()
              .frame(width: 20, height: 20, alignment: .trailing)
              .padding(.trailing, 70)
          }
          
        }
        .frame(width: 353, height: 75)
        .background(Color("BlockMe Yellow").clipShape(RoundedRectangle(cornerRadius:15)))
        .foregroundColor(.black)
        .offset(y: -15)
      }
    }
  }
}
