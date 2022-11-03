//
//  UserViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class UserViewModel: ObservableObject, Identifiable {
//  @Published var user: User
  private let path: String = "users"
  private let store = Firestore.firestore()
  
  init() {}
  
}
