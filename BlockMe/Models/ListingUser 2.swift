//
//  ListingUser.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/4/22.
//

import Foundation
import FirebaseFirestoreSwift

struct ListingUser: Identifiable, Codable {
  var id: String?
  var firstName: String
  var lastName: String
  var venmoHandle: String
  var phoneNumber: String
  var profileImageURL: String
  var rating: Float

  enum CodingKeys: String, CodingKey {
    case id
    case firstName
    case lastName
    case venmoHandle
    case phoneNumber
    case profileImageURL
    case rating
  }
}
