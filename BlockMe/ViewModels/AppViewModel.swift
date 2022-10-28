//
//  AppViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

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
  
  func validatePhoneNumber(number: String) -> Bool {
    let num = Int(number) ?? -1
    if num == -1 {
      print("Phone Number Error: not characters are numbers")
      return false
    }
    if number.count != 10 {
      print("Phone Number Error: invalid length, has to be 10 digits")
      return false
    }
    print("Phone number is good")
    return true
  }

  func isValidEmailAddr(email: String) -> Bool {
    let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"  // 1

    let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)  // 2

    return emailValidationPredicate.evaluate(with: email)  // 3
  }
  
  func validateFields(email: String, number: String) -> Bool {
    return isValidEmailAddr(email: email) && validatePhoneNumber(number: number)
  }
  
  // signs a new user up by creating a new entry in the auth table.
  // creates a corresponding entry in the users table
  // uploads their profile image to cloud storage
  func signUp(email: String, password: String, firstName: String, lastName: String, venmoHandle: String, phoneNumber: String, profileImage: UIImage) {
    auth.createUser(withEmail: email, password: password) { result, error in
      guard result != nil && error == nil else {
       
        // TODO handle specific errors
        print("error creating an account!")
        if let error = error {
          print("Error: \(error.localizedDescription).")

        }
        return
      }
      // upload image to cloud and return the URL
      let profileImageURL = self.uploadImageToCloud(image: profileImage)
      
      // store the user in the users table
      if let result = result {
        let userId = result.user.uid
        let user = User(id: userId, firstName: firstName, lastName: lastName, venmoHandle: venmoHandle, phoneNumber: phoneNumber, profileImageURL: profileImageURL)
        self.addUser(user)
        self.signedIn = true
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
  
  private func addUser(_ user: User) {
    let path: String = "users"
    let store = Firestore.firestore()

    do {
      let newUser = user
      _ = try store.collection(path).document(user.id!).setData(from: newUser)
    } catch {
      // TODO implement error handling other than crashing the app
      fatalError("Unable to add user: \(error.localizedDescription).")
    }
  }
  
  private func uploadImageToCloud(image: UIImage) -> String {
    return "images/H3A43UxfupQGyiTAApGAdT1ccmB2.jpg"
  }
}
