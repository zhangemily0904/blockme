//
//  DiningLocation.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import FirebaseFirestoreSwift

struct DiningLocation: Identifiable, Codable {
  @DocumentID var id: String?
  var name: String
  var tagColor: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case tagColor
  }
}
