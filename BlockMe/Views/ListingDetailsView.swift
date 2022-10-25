//
//  ListingDetailView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import SwiftUI

struct ListingDetailsView: View {
  var listing: Listing
    var body: some View {
      VStack(alignment: .leading) {
        Text(String(format: "$%.2f", listing.price))
        Text("Expires at \(listing.expirationTime.dateValue())")
      }
    }
  
  func getSellerInfo() {
    
  }
}

