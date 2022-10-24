//
//  ContentView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/23/22.
//

import SwiftUI

struct AppView: View {
    @ObservedObject var userRepository = UserRepository()
    var body: some View {
      List{
        ForEach(userRepository.users) { user in
          UserView(user: user)
        }
      }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
