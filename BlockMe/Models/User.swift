//
//  User.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
  @DocumentID var id: String?
  var firstName: String
  var lastName: String
  var venmoHandle: String
  var phoneNumber: String
  var profileImageURL: String
  var ratings: [Int]
  
  enum CodingKeys: String, CodingKey {
    case id
    case firstName
    case lastName
    case venmoHandle
    case phoneNumber
    case profileImageURL
    case ratings
  }
  
  func getAvgRating() -> Float {
    return self.ratings.count > 0 ? (Float(self.ratings.reduce(0, +)) / Float(self.ratings.count)) : 0
  }
}
