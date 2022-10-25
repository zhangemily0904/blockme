//
//  Review.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Review: Identifiable, Codable {
  @DocumentID var id: String?
  var reviewerId: String
  var revieweeId: String
  var numStars: Int   // assuming we only give whole number star reviews
  
  enum CodingKeys: String, CodingKey {
    case id
    case reviewerId
    case revieweeId
    case numStars
  }
}
