//
//  UIComponents.swift
//  BlockMe
//
//  Created by Brian Chou on 10/28/22.
//

import SwiftUI

struct RedButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .bold()
      .frame(width: 352, height: 57)
      .foregroundColor(Color.white)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color("BlockMe Red"))
      )
  }
}

struct InputField: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding()
      .frame(width: 352, height: 64)
      .overlay {
          RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(Color.black, lineWidth: 2)
      }
      .autocapitalization(.none)
      .disableAutocorrection(true)
  }
}
