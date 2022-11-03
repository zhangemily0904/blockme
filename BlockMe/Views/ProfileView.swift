//
//  ProfileView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import SwiftUI
import FirebaseAuth
struct ProfileView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  
    var body: some View {
      VStack {
        Text("Profile").font(.title)
        Text(appViewModel.auth.currentUser?.uid ?? "nope")
      }
    }
}
