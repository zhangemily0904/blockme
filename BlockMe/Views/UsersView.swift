//
//  UsersView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import SwiftUI

struct UsersView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @ObservedObject var userRepository = UserRepository()
  
    var body: some View {
      VStack {
        Text("Users").font(.title)
        List{
          ForEach(userRepository.users) { user in
            UserDetailView(user: user)
          }
        }
      }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
