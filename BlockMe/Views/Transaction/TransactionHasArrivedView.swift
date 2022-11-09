//
//  TransactionHasArrivedView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/8/22.
//

import SwiftUI

struct TransactionHasArrivedView: View {
  @ObservedObject var listingRepository: ListingRepository
  @ObservedObject var listingViewModel: ListingViewModel
  var arrived: String
  @State var showErrorAlert = false // alert for errors
  @State var showAlert = false // alert for confirming cancel / decline order
  @State private var alertMsg = ""
  
    var body: some View {
      VStack {
        if var listing = self.listingViewModel.listing {
          let name = (arrived == "seller") ? listing.seller.firstName : (listing.buyer?.firstName ?? "XXX")
          let image = (arrived == "seller") ? listingViewModel.sellerImage : listingViewModel.buyerImage
          let phoneNumber = (arrived == "seller") ?  String(listing.seller.phoneNumber) : String(listing.buyer?.phoneNumber ?? "(XXX) XXX - XXXX")
          
          Text("\(name) has arrived at \(listing.selectedLocation?.rawValue ?? "Location")").font(.medLarge)
          if let image = image {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .clipShape(Circle())
          }
          Text(phoneNumber)
          
          Button(action: {
            // if the person who has arrived is the buyer, then only the seller will see this screen so we update seller status
            if arrived == "buyer" {
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
            showAlert = true
            alertMsg = "Are you sure you want to cancel this order?"
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
