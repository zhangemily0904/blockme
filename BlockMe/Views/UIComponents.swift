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
      .frame(width: 352, height: 57)
      .foregroundColor(Color.white)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color("BlockMe Red"))
      )
  }
}
  
struct SmallWhiteButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: 200, height: 40)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(.black)
      )
  }
}

struct SmallRedButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: 200, height: 40)
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

struct CapitalizationInputField: TextFieldStyle {
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding()
      .frame(width: 352, height: 64)
      .overlay {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(Color.black, lineWidth: 2)
      }
      .autocapitalization(.words)
      .disableAutocorrection(true)
  }
}

extension Capsule {
  static let UC = AnyView(Capsule().fill(Color("UC Green")).frame(width: 140, height: 22).overlay(Text("\(DiningLocation.UC.rawValue)").font(.regSmall)).padding(3).padding(.bottom, 6))
  static let Resnik = AnyView(Capsule().fill(Color("Resnik Purple")).frame(width: 70, height: 22).overlay(Text("\(DiningLocation.Resnik.rawValue)").font(.regSmall)).padding(3).padding(.bottom, 6))
  static let Tepper = AnyView(Capsule().fill(Color("Tepper Lilic")).frame(width: 70, height: 22).overlay(Text("\(DiningLocation.Tepper.rawValue)").font(.regSmall)).padding(3).padding(.bottom, 6))
  static let LaPrimaWean = AnyView(Capsule().fill(Color("La Prima(W) Pink")).frame(width: 140, height: 22).overlay(Text("\(DiningLocation.LaPrimaWean.rawValue)").font(.regSmall)).padding(3).padding(.bottom, 6))
  static let LaPrimaGates = AnyView(Capsule().fill(Color("La Prima(G) Pink")).frame(width: 140, height: 22).overlay(Text("\(DiningLocation.LaPrimaGates.rawValue)").font(.regSmall)).padding(3).padding(.bottom, 6))
}

extension Circle {
  static let availableCircle = AnyView(Circle().fill(Color("Expiration Green")).frame(width: 8, height: 8))
  static let limitCircle = AnyView(Circle().fill(Color("Expiration Yellow")).frame(width: 8, height: 8))
  static let unavailableCircle = AnyView(Circle().fill(Color("Expiration Red")).frame(width: 8, height: 8))
}
