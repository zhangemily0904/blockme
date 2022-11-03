//
//  UserViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import SwiftUI

class UserViewModel: ObservableObject, Identifiable {
  @Published var user: User? = nil
  @Published var profileImage: UIImage? = nil
  var id: String
  private let path: String = "users"
  private let store = Firestore.firestore()
  
  init(id: String) {
    self.id = id
    self.get()
  }
  
  // fetches user data from firestore
  func get() {
    store.collection(path).document(self.id)
      .addSnapshotListener { documentSnapshot, error in
        if let error = error {
          print("Error getting user info: \(error.localizedDescription)")
          return
        }
        print("getting user info for \(self.id)")
        
        guard let dc = documentSnapshot else {
          print("failed to get document")
          return
        }
        
        self.user = try? dc.data(as: User.self)
        self.retrieveProfileImage()
      }
  }
  
  func retrieveProfileImage(){
    guard let user = self.user else {
      print("Can't retrieve image of a nil user.")
      return
    }
    
    let storageRef = Storage.storage().reference()
    let fileRef = storageRef.child(user.profileImageURL)

    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
      if error == nil && data != nil {
        print("got image")
        self.profileImage = UIImage(data: data!)
        return
      }
      
      print("Error fetching image of path \(user.profileImageURL) \(error!.localizedDescription)")
    }
  }
  
}
