//
//  UsersView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseStorage

struct UserDetailView: View {
    @ObservedObject var userRepository = UserRepository()
    var user: User
    @State var profileImage: UIImage? = nil
  
    var body: some View {
      VStack(alignment: .leading) {
        if let profileImage = profileImage {
          Image(uiImage: profileImage)
            .resizable()
            .scaledToFit()
        }
        Text(user.firstName + " " + user.lastName).font(.title3)
        HStack {
          Text("Venmo: ").bold()
          Text(user.venmoHandle)
        }
        HStack {
          Text("Phone #: ").bold()
          Text(user.phoneNumber)
        }
      }
      .onAppear {
        retrieveProfileImage()
      }
    }
    
  func retrieveProfileImage() {
    let storageRef = Storage.storage().reference()
    let fileRef = storageRef.child(user.profileImageURL)
    
    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
      if error == nil && data != nil {
        profileImage = UIImage(data: data!)
        return
      }
      
      print("Error fetching image of path \(user.profileImageURL)")
    }
  }
  
}
