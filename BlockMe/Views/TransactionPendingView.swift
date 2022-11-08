//
//  TransactionPendingView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/8/22.
//

import SwiftUI

struct TransactionPendingView: View {
  @ObservedObject var listingRepository: ListingRepository = ListingRepository()
  @ObservedObject var listingViewModel: ListingViewModel
  var isSeller: Bool
  @State var showErrorAlert = false
  @State private var alertMsg = ""
  
  
  var body: some View {
    VStack {
      if self.isSeller {
        self.sellerContent
      }
      else {
        self.buyerContent
      }
    }.alert(alertMsg, isPresented: $showErrorAlert) {
      Button("Ok", role: .cancel) {
        showErrorAlert = false
      }
    }
  }
  
  var sellerContent: some View {
    VStack {
      if var listing = listingViewModel.listing {
        Text("\(listing.buyer?.firstName ?? "XXX") wants to buy your block").font(.medLarge)
        if let buyerImage = listingViewModel.buyerImage {
          Image(uiImage: buyerImage)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
        }
        
        HStack {
          Text("$\(listing.price)")
          Text(listing.selectedLocation?.rawValue ?? "Error: No location found")
        }
        
        Button(action: {
          listing.sellerStatus = SellerStatus.acceptedTransaction
          if !listingRepository.update(listing: listing) {
            alertMsg = "Error accepting this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("Accept")
        }.buttonStyle(RedButton())
        
        Button(action: {
          if !listingRepository.cancelTransactionForListing(listing: listing) {
            alertMsg = "Error cancelling this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("Decline")
        }.buttonStyle(SmallWhiteButton())
      }
    }
  }
  
  var buyerContent: some View {
    VStack {
      if let listing = listingViewModel.listing {
        Text("Waiting for \(listing.seller.firstName) to accept order").font(.medLarge)
        Text("PLACEHOLDER: Image goes here").bold()
        
        Button(action: {}) {
          Text("Cancel")
        }.buttonStyle(SmallWhiteButton())
      }
    }
  }
}
