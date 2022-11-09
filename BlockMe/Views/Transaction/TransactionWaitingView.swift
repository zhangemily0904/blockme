//
//  TransactionWaitingView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/8/22.
//

import SwiftUI

struct TransactionWaitingView: View {
  @ObservedObject var listingRepository: ListingRepository
  @ObservedObject var listingViewModel: ListingViewModel
  var waitingFor: String
  @State var showErrorAlert = false
  @State private var alertMsg = ""
  
    var body: some View {
      VStack {
        if let listing = self.listingViewModel.listing {
          let name = (waitingFor == "seller") ? listing.seller.firstName : (listing.buyer?.firstName ?? "XXX")
          let image = (waitingFor == "seller") ? listingViewModel.sellerImage : listingViewModel.buyerImage
          let phoneNumber = (waitingFor == "seller") ?  String(listing.seller.phoneNumber) : String(listing.buyer?.phoneNumber ?? "(XXX) XXX - XXXX")
          
          Text("Waiting for \(name) to arrive").font(.medLarge)
          if let image = image {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .clipShape(Circle())
          }
          Text(phoneNumber)
          
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
