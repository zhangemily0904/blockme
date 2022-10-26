//
//  AppViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import Foundation
import FirebaseAuth

class AppViewModel: ObservableObject {
  @Published var signedIn = false
 
  let auth = Auth.auth()
  
  var isSignedIn: Bool {
    auth.currentUser != nil
  }
  
  init() {
    signedIn = isSignedIn
  }
  
  func signIn(email: String, password: String) {
    auth.signIn(withEmail: email, password: password) { result, error in
      guard result != nil && error == nil else {
        // TODO handle specific errors
        print("error signing in!")
        return
      }
      
      // success
      self.signedIn = true
      
    }
  }
  
  func signUp(email: String, password: String, user: User) {
    auth.createUser(withEmail: email, password: password) { result, error in
      guard result != nil && error == nil else {
        // TODO handle specific errors
        print("error creating an account!")
        return
      }
      
      // success
      self.signedIn = true
      // create user document in firestore
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
  
}
