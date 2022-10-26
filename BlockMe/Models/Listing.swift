//
//  Listing.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
enum BuyerStatus: String, Codable {
  case requested = "requested"
  case arrivedAtLocation = "arrivedAtLocation"
  case completedPayment = "completedPayment"
}

enum SellerStatus: String, Codable {
  case begunTransaction = "begunTransaction"
  case arrivedAtLocation = "arrivedAtLocation"
  case paymentRecieved = "paymentReceived"
}

struct Listing: Identifiable, Codable {
  @DocumentID var id: String?
  var seller: ListingUser
  var buyer: ListingUser?
  var price: Float
  var expirationTime: Date
  var completedTime: Date?  
  var availableLocations: [DiningLocation]
  var buyerStatus: BuyerStatus?
  var sellerStatus: SellerStatus?
  
  enum CodingKeys: String, CodingKey {
    case id
    case seller
    case buyer
    case price
    case expirationTime
    case completedTime
    case availableLocations
    case buyerStatus
    case sellerStatus
  }
}

