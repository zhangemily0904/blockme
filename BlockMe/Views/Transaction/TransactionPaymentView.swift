//
//  TransactionPaymentView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/8/22.
//

import SwiftUI

struct TransactionPaymentView: View {
  @ObservedObject var listingRepository: ListingRepository
  @ObservedObject var listingViewModel: ListingViewModel
  var isSeller: Bool
    var body: some View {
      Text("Confirm and Pay").font(.medLarge)
    }
}

