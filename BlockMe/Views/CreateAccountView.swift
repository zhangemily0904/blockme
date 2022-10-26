//
//  CreateAccountView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import SwiftUI

struct CreateAccountView: View {
  @EnvironmentObject var appViewModel: AppViewModel
    var body: some View {
      Text("Sign Up").font(.title)
      Text("Create an account. It's free")
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
