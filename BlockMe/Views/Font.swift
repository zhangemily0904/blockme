//
//  Font.swift
//  BlockMe
//
//  Created by Wen Shan Jiang on 11/4/22.
//

import Foundation
import SwiftUI


extension Font {
  
  static let semiLarge = Font.custom(PingFangSC.semibold, size: 36)
  static let semiMed = Font.custom(PingFangSC.semibold, size: 16)
  static let semiSmall = Font.custom(PingFangSC.semibold, size: 14)
  
  static let medLarge = Font.custom(PingFangSC.medium, size: 32)
  static let medMed = Font.custom(PingFangSC.medium, size: 20)
  static let medSmall = Font.custom(PingFangSC.medium, size: 16)
  static let medTiny = Font.custom(PingFangSC.medium, size: 12)
  
  static let regLarge = Font.custom(PingFangSC.regular, size: 20)
  static let regMed = Font.custom(PingFangSC.regular, size: 16)
  static let regSmall = Font.custom(PingFangSC.regular, size: 14)
  static let regTiny = Font.custom(PingFangSC.regular, size: 12)
}

struct PingFangSC {
  static let familyRoot   = "PingFangSC"
  
  static let semibold     = "\(familyRoot)-Semibold"
  static let medium       = "\(familyRoot)-Medium"
  static let regular      = "\(familyRoot)-Regular"
  static let light        = "\(familyRoot)-Light"
}
