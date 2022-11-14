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
      
      // this view serves as the control flow for the the transaction process by observing the buyerStatus and sellerStatus of the listing
      if let listing = listingViewModel.listing {
        if listing.buyerStatus == BuyerStatus.requested && listing.sellerStatus == nil {
          TransactionPendingView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, isSeller: self.isSeller)
        }
        else if listing.buyerStatus == BuyerStatus.requested && listing.sellerStatus == SellerStatus.acceptedTransaction {
          TransactionMeetUpView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, isSeller: self.isSeller)
        }
        else if listing.buyerStatus == BuyerStatus.arrivedAtLocation && listing.sellerStatus == SellerStatus.acceptedTransaction {
          if self.isSeller {
            TransactionHasArrivedView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, arrived: "buyer")
          } else {
            TransactionWaitingView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, waitingFor: "seller", msgPostfix: "arrive")
          }
        }
        else if listing.buyerStatus == BuyerStatus.requested && listing.sellerStatus == SellerStatus.arrivedAtLocation {
          if self.isSeller {
            TransactionWaitingView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, waitingFor: "buyer", msgPostfix: "arrive")
          } else {
            TransactionHasArrivedView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, arrived: "seller")
          }
        }
        else if listing.buyerStatus == BuyerStatus.arrivedAtLocation && listing.sellerStatus == SellerStatus.arrivedAtLocation {
          TransactionPaymentView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, isSeller: self.isSeller)
        }
        else if listing.buyerStatus == BuyerStatus.completedPayment && listing.sellerStatus != SellerStatus.paymentRecieved {
          if self.isSeller {
            TransactionPaymentView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, isSeller: self.isSeller)
          } else {
            TransactionConfirmingView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, waitingFor: "seller", msgPostfix: "confirm")
          }
        }
        else if listing.buyerStatus != BuyerStatus.completedPayment && listing.sellerStatus == SellerStatus.paymentRecieved {
          if self.isSeller {
            TransactionConfirmingView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, waitingFor: "buyer", msgPostfix: "confirm")
          } else {
            TransactionPaymentView(listingRepository: self.listingRepository, listingViewModel: self.listingViewModel, isSeller: self.isSeller)
          }
        }
      }
    }
  }
}
