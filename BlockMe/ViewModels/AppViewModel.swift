//
//  AppViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class AppViewModel: ObservableObject {
  @Published var signedIn = false
  @Published var userViewModel: UserViewModel? = nil
  @Published var tabsDisabled = false
  
  let auth = Auth.auth()
  let storage = Storage.storage().reference()
  
  var isSignedIn: Bool {
    auth.currentUser != nil
  }
  
  var currentUserId: String? {
    auth.currentUser?.uid
  }
  
  init() {
    signedIn = isSignedIn
    
    if signedIn {
      self.loadUser()
    }
  }
  
  func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
    auth.signIn(withEmail: email, password: password) { result, error in
      guard result != nil && error == nil else {
        completion(error)
        return
      }
      
      // success
      self.signedIn = true
      self.loadUser()
      completion(error)
    }
  }
  
  // signs a new user up by creating a new entry in the auth table.
  // creates a corresponding entry in the users table
  // uploads their profile image to cloud storage
  func signUp(email: String, password: String, firstName: String, lastName: String, venmoHandle: String, phoneNumber: String, profileImage: UIImage, completion: @escaping (String?) -> Void) {
    auth.createUser(withEmail: email, password: password) { result, error in
      guard error == nil else {
        completion(error!.localizedDescription)
        return
      }
      
      if let result = result {
        let userId = result.user.uid
        // upload image to cloud and return the URL
        StorageViewModel.uploadImageToCloud(uid: userId, image: profileImage) { (path, error) in
          guard let path = path else {
            if let error = error {
              completion(error.localizedDescription)
            } else {
              completion("Unable to upload profile picture.")
            }
            return
          }
          
          // create user in users collection
          let user = User(id: userId, firstName: firstName, lastName: lastName, venmoHandle: venmoHandle, phoneNumber: phoneNumber, profileImageURL: path)
          self.addUser(user) { error in
            guard error == nil else {
              completion(error!.localizedDescription)
              return
            }
            self.signedIn = true
            self.loadUser()
          }
        }
      }
    }
  }
  
  func signOut() {
    do {
      try Auth.auth().signOut()
      self.signedIn = false
    } catch {
      print("Sign out error")
    }
  }
  
  // PRIVATE HELPER FUNCTIONS //
  
  private func addUser(_ user: User, completion: @escaping (Error?) -> Void) {
    let path: String = "users"
    let store = Firestore.firestore()

    do {
      let newUser = user
      _ = try store.collection(path).document(user.id!).setData(from: newUser)
      completion(nil)
    } catch {
      print("Unable to add user: \(error.localizedDescription).")
      completion(error)
    }
  }
  
  private func loadUser() {
    guard let uid = self.currentUserId else {
      print("error getting signed in user info.")
      return
    }
    userViewModel = UserViewModel(id: uid)
  }
}
