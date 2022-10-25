//
//  DiningLocation.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct DiningLocation: Identifiable, Codable {
  @DocumentID var id: String?
  var name: String
  var tagColorStr: String
  
  // converts string of "0 0 0" to rgb color(0, 0, 0)
  var tagColor: Color {
    let vals = tagColorStr.split(separator: " ")
    if vals.count != 3 {
      return Color(red: 0.0, green: 0.0, blue: 0.0)
    }
    let red = Double(vals[0]) ?? 0.0
    let green = Double(vals[1]) ?? 0.0
    let blue = Double(vals[2]) ?? 0.0
    return Color(red: red, green: green, blue: blue)
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case tagColorStr = "tagColor"
  }
}
