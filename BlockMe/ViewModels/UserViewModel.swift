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
        
        guard let dc = documentSnapshot else {
          print("failed to get document")
          return
        }
        
        self.user = try? dc.data(as: User.self)
        
        guard let user = self.user else {
          print("Failed to parse user info.")
          return
        }
        
        StorageViewModel.retrieveProfileImage(imagePath: user.profileImageURL) { image in
          self.profileImage = image
        }
      }
  }
  
  func update(user: User) -> Bool {
    do {
      try store.collection(path).document(self.id).setData(from: user)
      return true
    } catch {
      print("Unable to update user: \(error.localizedDescription).")
      return false
    }
  }
  
  static func addRating(userId: String, rating: Int) {
    let store = Firestore.firestore()
    store.collection("users").document(userId).getDocument { (document, error) in
      if let error = error {
        print("Error getting user info: \(error.localizedDescription)")
        return
      }
      
      guard let doc = document else {
        print("failed to get document")
        return
      }
      
      let user = try? doc.data(as: User.self)
      guard var user = user else {
        print("failed to parse user info")
        return
      }
      
      user.ratings.append(rating)
      
      do {
        try store.collection("users").document(userId).setData(from: user)
      } catch {
        print("Unable to add review for user: \(error.localizedDescription).")
      }
    }
  }
}
