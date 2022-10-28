//
//  ContentView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/23/22.
//

import SwiftUI

struct AppView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  
    var body: some View {
      NavigationView {
        if appViewModel.signedIn {
          TabView {
            UsersView()
              .tabItem {
                Image(systemName: "person.2")
                Text("Users")
              }
            
            MarketPlaceView()
              .tabItem {
                Image(systemName: "house")
                Text("Marketplace")
              }
            
            ProfileView()
              .tabItem {
                Image(systemName: "person")
                Text("Profile")
              }
          }
        } else if appViewModel.uploadPicture {
          ChooseProfileImageView()
        } else {
          LoginView()
        }
      }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
