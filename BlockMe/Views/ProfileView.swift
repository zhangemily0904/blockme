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
        Text("Profile").font(.title)
        
        if let userViewModel = appViewModel.userViewModel {
          if let profileImage = userViewModel.profileImage {
            Image(uiImage: profileImage)
              .resizable()
              .scaledToFit()
              .clipShape(Circle())
          }
          if let user = userViewModel.user {
            Text("\(user.firstName) \(user.lastName)").font(.headline)
          }
          
          Spacer()
          NavigationLink("Manage Account", destination: EditProfileView())
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
