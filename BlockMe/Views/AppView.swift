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
            MarketPlaceView()
              .tabItem {
                Image(systemName: "house")
                Text("Marketplace")
              }
            
            OrdersView()
              .tabItem {
                Image(systemName: "bag.fill")
                Text("Orders")
              }
            ProfileView()
              .tabItem {
                Image(systemName: "person")
                Text("Profile")
              }
          }
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
