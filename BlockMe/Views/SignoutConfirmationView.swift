//
//  SignoutConfirmationView.swift
//  BlockMe
//
//  Created by Emily Zhang on 12/7/22.
//

import SwiftUI

struct SignoutConfirmationView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
      VStack{
        Text("Are you sure?").font(.medMed).frame(width: 352, alignment: .leading)
          .padding(.bottom, 30)
        Button(action: {
          appViewModel.signOut()
        }) {
          Text("Log Out").font(.medSmall)
        }
        .buttonStyle(RedButton())

        Button(action: {dismiss()}) {
          Text("Cancel")
        }.buttonStyle(WhiteButton())
          .font(.medSmall)
      }
      .frame(width: 352, alignment: .leading)

    }
}

struct SignoutConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        SignoutConfirmationView()
    }
}
