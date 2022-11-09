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
  @State var showErrorAlert = false // alert for errors
  @State var showAlert = false // alert for confirming cancel / decline order
  @State private var alertMsg = ""
  
    var body: some View {
      VStack {
        if self.isSeller {
          self.sellerContent
        } else {
          self.buyerContent
        }
      }.alert(alertMsg, isPresented: $showAlert) {
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
  
  var sellerContent: some View {
    VStack {
      if var listing = listingViewModel.listing {
        Text("Complete Transaction").font(.medLarge)
        
        VStack {
          HStack {
            Text("Buyer Venmo:").frame(maxWidth: .infinity, alignment: .leading)
            Text(listing.buyer?.venmoHandle ?? "").frame(maxWidth: .infinity, alignment: .trailing)
          }
          HStack {
            Text("Price per block:").frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "$%.2f", listing.price)).frame(maxWidth: .infinity, alignment: .trailing)
          }
          HStack {
            Text("Quantity:").frame(maxWidth: .infinity, alignment: .leading)
            Text("1x").frame(maxWidth: .infinity, alignment: .trailing)
          }
          Divider().frame(height: 15)
          HStack {
            Text("Total").frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "$%.2f", listing.price)).frame(maxWidth: .infinity, alignment: .trailing)
          }
        }.frame(width: 300) // TODO: make responsive? @wenshan
        
        
        Button(action: {
          listing.sellerStatus = SellerStatus.paymentRecieved
          
          if listing.buyerStatus == BuyerStatus.completedPayment {
            listing.completedTime = Date.now
          }
          
          if !listingRepository.update(listing: listing) {
            alertMsg = "Error accepting this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("Confirm Payment Received")
        }.buttonStyle(RedButton())
        
        Button(action: {
          showAlert = true
          alertMsg = "Are you sure you want to cancel this order?"
        }) {
          Text("Cancel")
        }.buttonStyle(SmallWhiteButton())
      }
    }
  }
  
  var buyerContent: some View {
    VStack {
      if var listing = listingViewModel.listing {
        Text("Confirm and Pay").font(.medLarge)
        
        VStack {
          HStack {
            Text("Seller Venmo:").frame(maxWidth: .infinity, alignment: .leading)
            Text(listing.seller.venmoHandle).frame(maxWidth: .infinity, alignment: .trailing)
          }
          HStack {
            Text("Price per block:").frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "$%.2f", listing.price)).frame(maxWidth: .infinity, alignment: .trailing)
          }
          HStack {
            Text("Quantity:").frame(maxWidth: .infinity, alignment: .leading)
            Text("1x").frame(maxWidth: .infinity, alignment: .trailing)
          }
          Divider().frame(height: 15)
          HStack {
            Text("Total").frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "$%.2f", listing.price)).frame(maxWidth: .infinity, alignment: .trailing)
          }
        }.frame(width: 300) // TODO: make responsive? @wenshan
        
        
        Button(action: {
          listing.buyerStatus = BuyerStatus.completedPayment
          
          if listing.sellerStatus == SellerStatus.paymentRecieved {
            listing.completedTime = Date.now
          }
          
          if !listingRepository.update(listing: listing) {
            alertMsg = "Error accepting this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("I Have Paid")
        }.buttonStyle(RedButton())
        
        Button(action: {
          showAlert = true
          alertMsg = "Are you sure you want to cancel this order?"
        }) {
          Text("Cancel")
        }.buttonStyle(SmallWhiteButton())
      }
    }  }
}

