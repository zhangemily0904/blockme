//
//  AppViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


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
  
  func signUp(email: String, password: String, firstName: String, lastName: String, venmoHandle: String, phoneNumber: String) {
    let profileImageURL = "images/H3A43UxfupQGyiTAApGAdT1ccmB2.jpg"
    auth.createUser(withEmail: email, password: password) { result, error in
      guard result != nil && error == nil else {
       
        // TODO handle specific errors
        print("error creating an account!")
        if let error = error {
          print("Error: \(error.localizedDescription).")

        }
        return
      }
      
      // success
      self.signedIn = true
      // TODO create user document in firestore
      if let result = result {
        let userId = result.user.uid
        let user = User(id: userId, firstName: firstName, lastName: lastName, venmoHandle: venmoHandle, phoneNumber: phoneNumber, profileImageURL: profileImageURL)
        self.addUser(user)
      }
    }
  }
  
  private func addUser(_ user: User) {
    let path: String = "users"
    let store = Firestore.firestore()

    do {
      let newUser = user
      _ = try store.collection(path).addDocument(from: newUser)
    } catch {
      fatalError("Unable to add user: \(error.localizedDescription).")
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
