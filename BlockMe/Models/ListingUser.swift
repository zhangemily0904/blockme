//
//  ListingUser.swift
//  BlockMe
//
//  Created by Brian Chou on 10/26/22.
//

import Foundation

struct ListingUser: Identifiable, Codable {
  var id: String
  var firstName: String
  var profileImageURL: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case firstName
    case profileImageURL
  }
}
