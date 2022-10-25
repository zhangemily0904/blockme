//
//  UserViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import Combine

class UserViewModel: ObservableObject, Identifiable {
  @Published var user: User
  private var cancellables: Set<AnyCancellable> = []
  var id = ""
  
  init(user: User) {
    self.user = user
    $user
      .compactMap { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
  }
}
