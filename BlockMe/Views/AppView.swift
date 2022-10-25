//
//  ContentView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/23/22.
//

import SwiftUI

struct AppView: View {
    var body: some View {
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
      }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
