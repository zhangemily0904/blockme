//
//  TransactionView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/7/22.
//

import SwiftUI

struct TransactionView: View {
  @ObservedObject var listingRepository: ListingRepository = ListingRepository()
  @ObservedObject var listingViewModel: ListingViewModel
  var isSeller: Bool
  
  init(listingId: String, isSeller: Bool) {
    listingViewModel = ListingViewModel(id: listingId)
    self.isSeller = isSeller
  }
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        
        if let listing = listingViewModel.listing {
          if listing.buyerStatus == BuyerStatus.requested && listing.sellerStatus == nil {
            TransactionPendingView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, isSeller: self.isSeller)
          }
          else if listing.buyerStatus == BuyerStatus.requested && listing.sellerStatus == SellerStatus.acceptedTransaction {
//            TransactionMeetUpView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, isSeller: self.isSeller)
          }
        }
      }
    }
  
}
