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
      .frame(width: 200, height: 40)
      .foregroundColor(Color.white)
      .background(
        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("BlockMe Red"))
      )
  }
}
