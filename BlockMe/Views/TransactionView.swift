//
//  TransactionView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/7/22.
//

import SwiftUI

struct TransactionView: View {
  var listingId: String
  var isSeller: Bool
    var body: some View {
      VStack {
        Text("transaction home")
        Text("Listing ID: \(listingId)")
        Text(isSeller ? "Seller" : "Buyer")
      }
    }
}
