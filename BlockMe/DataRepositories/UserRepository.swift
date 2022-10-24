//
//  UserRepository.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
  private let path: String = "users"
  private let store = Firestore.firestore()
  
  @Published var users: [User] = []
  private var cancellables: Set<AnyCancellable> = []
  
  init() {
    self.get()
  }
  
  func get() {
    store.collection(path)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          print("Error getting books: \(error.localizedDescription)")
          return
        }

        self.users = querySnapshot?.documents.compactMap { document in
          try? document.data(as: User.self)
        } ?? []
      }
  }
}
