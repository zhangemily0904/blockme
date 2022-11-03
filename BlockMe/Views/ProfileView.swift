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
  
  // need to nest content view in order to get access to appViewModel on init
  struct content: View {
    @ObservedObject var userViewModel: UserViewModel
    
    init(id: String) {
      userViewModel = UserViewModel(id: id)
    }
    
    var body: some View {
      VStack {
        if let user = userViewModel.user {
          Text("\(user.firstName) \(user.lastName)")
        }
        if let profileImage = userViewModel.profileImage {
          Image(uiImage: profileImage)
            .resizable()
            .scaledToFit()
        }
      }
    }
  }
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        VStack {
          Text("Profile").font(.title)
          if let uid = appViewModel.currentUserId {
            content(id: uid)
          }
          
          Button(action: {
            appViewModel.signOut()
          }) {
            Text("Sign Out").bold()
          }
        }
      }
    }
}
