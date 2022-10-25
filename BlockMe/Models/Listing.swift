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
  var sellerId: String
  var buyerId: String?
  var price: Float
  var expirationTime: Timestamp  // ideally want to convert to Date instead
  var availableLocationIds: [String]
  var buyerStatus: BuyerStatus?
  var sellerStatus: SellerStatus?
  
  enum CodingKeys: String, CodingKey {
    case id
    case sellerId
    case buyerId
    case price
    case expirationTime
    case availableLocationIds
    case buyerStatus
    case sellerStatus
  }
}
