//
//  EditProfileView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/2/22.
//

import SwiftUI

struct EditProfileView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @ObservedObject var userViewModel: UserViewModel
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        VStack {
          Text("Update Your Information").font(.title)
        }
      }
      
    }
}
