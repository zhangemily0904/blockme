//
//  TransactionWaitingView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/8/22.
//

import SwiftUI

// generic waiting room for transactions
struct TransactionWaitingView: View {
  @ObservedObject var listingRepository: ListingRepository
  @ObservedObject var listingViewModel: ListingViewModel
  var waitingFor: String
  var msgPostfix: String
  @State var showErrorAlert = false // alert for errors
  @State var showAlert = false // alert for confirming cancel / decline order
  @State private var alertMsg = ""
  
    var body: some View {
      VStack {
        if let listing = self.listingViewModel.listing {
          let name = (waitingFor == "seller") ? listing.seller.firstName : (listing.buyer?.firstName ?? "XXX")
          let image = (waitingFor == "seller") ? listingViewModel.sellerImage : listingViewModel.buyerImage
          let phoneNumber = (waitingFor == "seller") ?  String(listing.seller.phoneNumber) : String(listing.buyer?.phoneNumber ?? "(XXX) XXX - XXXX")
          
          Text("Waiting for \(name) to \(msgPostfix)").font(.medLarge)
          if let image = image {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .clipShape(Circle())
          }
          Text(phoneNumber)
          
          Button(action: {
            alertMsg = "Are you sure you want to cancel this order?"
            showAlert = true
          }) {
            Text("Cancel")
          }.buttonStyle(SmallWhiteButton())
        }
      }.alert(alertMsg, isPresented: $showErrorAlert) {
        Button("Ok", role: .cancel) {
          showErrorAlert = false
        }
      }
      .alert(alertMsg, isPresented: $showAlert) {
        Button("Yes", role: .destructive) {
          showErrorAlert = false
          if var listing = listingViewModel.listing {
            if !listingRepository.cancelTransactionForListing(listing: listing) {
              alertMsg = "Error cancelling this order. Please try again."
              showErrorAlert = true
            }
          }
        }
        Button("No", role: .cancel) {
          showErrorAlert = false
        }
      }
    }
}
