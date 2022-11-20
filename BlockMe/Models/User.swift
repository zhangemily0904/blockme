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
  
  func getAvgRating() -> Int {
    // add denominator - 1 to sum of ratings to round int division up
    return self.ratings.count > 0 ? ((self.ratings.reduce(0, +) + (self.ratings.count - 1)) / self.ratings.count) : 0
  }
}
