//
//  TransactionMeetUpView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/8/22.
//

import SwiftUI

struct TransactionMeetUpView: View {
  @ObservedObject var listingRepository: ListingRepository
  @ObservedObject var listingViewModel: ListingViewModel
  var isSeller: Bool
  @State var showErrorAlert = false
  @State private var alertMsg = ""
  
  var body: some View {
    self.content
  }
  
  var content: some View {
    VStack {
      if var listing = listingViewModel.listing {
        let name = self.isSeller ? (listing.buyer?.firstName ?? "XXX") : listing.seller.firstName
        let image = self.isSeller ? listingViewModel.buyerImage : listingViewModel.sellerImage
        let phoneNumber = self.isSeller ? String(listing.buyer?.phoneNumber ?? "(XXX) XXX - XXXX") : String(listing.seller.phoneNumber)
        Text("Meet \(name) at \(listing.selectedLocation?.rawValue ?? "Location")").font(.medLarge)
        if let buyerImage = image {
          Image(uiImage: buyerImage)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
        }
        Text(phoneNumber)
        
        Button(action: {
          if self.isSeller {
            listing.sellerStatus = SellerStatus.arrivedAtLocation
          } else {
            listing.buyerStatus = BuyerStatus.arrivedAtLocation
          }
          
          if !listingRepository.update(listing: listing) {
            alertMsg = "Error accepting this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("I Have Arrived")
        }.buttonStyle(RedButton())
        
        Button(action: {
          if !listingRepository.cancelTransactionForListing(listing: listing) {
            alertMsg = "Error cancelling this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("Cancel")
        }.buttonStyle(SmallWhiteButton())
      }
    }.alert(alertMsg, isPresented: $showErrorAlert) {
      Button("Ok", role: .cancel) {
        showErrorAlert = false
      }
    }
  }
}
