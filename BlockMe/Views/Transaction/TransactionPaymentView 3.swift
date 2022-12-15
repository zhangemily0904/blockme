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
  @State private var drawingWidth = false
  
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
        
        HStack {
          Rectangle.completed.padding(.trailing, 2)
          Rectangle.completed.padding(.trailing, 2)
          Rectangle.completed.padding(.trailing, 2)
          ZStack(alignment: .leading) {
            Rectangle.pending
            Rectangle()
              .fill(Color("BlockMe Red"))
              .frame(width: drawingWidth ? 48 : 0, alignment: .leading)
              .animation(.easeInOut(duration: 3).repeatForever(autoreverses: false), value: drawingWidth)
          }
          .frame(width: 48, height: 13)
          .onAppear {
            drawingWidth.toggle()
          }.padding(.trailing, 2)
          Rectangle.pending.padding(.trailing, 2)
          Rectangle.pending
        }
         .padding(.bottom, 30)
        
        Text("Complete Transaction").font(.medMedLarge)
        
        VStack {
          HStack {
            Text("Buyer Venmo:").font(.regLarge).frame(maxWidth: .infinity, alignment: .leading)
            Text(listing.buyer?.venmoHandle ?? "").font(.regLarge).frame(maxWidth: .infinity, alignment: .trailing)
          }.padding(.bottom, 5)
          HStack {
            Text("Price per block:").font(.regLarge).frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "$%.2f", listing.price)).font(.regLarge).frame(maxWidth: .infinity, alignment: .trailing)
          }.padding(.bottom, 5)
          HStack {
            Text("Quantity:").font(.regLarge).frame(maxWidth: .infinity, alignment: .leading)
            Text("1x").font(.regLarge).frame(maxWidth: .infinity, alignment: .trailing)
          }.padding(.bottom, 5)
          Divider().frame(height: 15)
          HStack {
            Text("Total").font(.regLarge).frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "$%.2f", listing.price)).font(.regLarge).frame(maxWidth: .infinity, alignment: .trailing)
          }
        }.frame(width: 352)
          .padding(.bottom, 30)
          .padding(.top, 30)
        
        
        Button(action: {
          listing.sellerStatus = SellerStatus.paymentRecieved
          
          if listing.buyerStatus == BuyerStatus.completedPayment {
            listing.completedTime = Date.now
          }
          
          if !listingRepository.update(listing: listing) {
            alertMsg = "Error updating this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("Confirm Payment Received").font(.medSmall)
        }.buttonStyle(RedButton())
          .padding(.bottom, 20)
        
        Button(action: {
          showAlert = true
          alertMsg = "Are you sure you want to cancel this order?"
        }) {
          Text("Cancel").font(.medSmall)
        }.buttonStyle(WhiteButton())
      }
    }
  }
  
  var buyerContent: some View {
    VStack {
      if var listing = listingViewModel.listing {
        
        
        HStack {
          Rectangle.completed.padding(.trailing, 2)
          Rectangle.completed.padding(.trailing, 2)
          Rectangle.completed.padding(.trailing, 2)
          ZStack(alignment: .leading) {
            Rectangle.pending
            Rectangle()
              .fill(Color("BlockMe Red"))
              .frame(width: drawingWidth ? 48 : 0, alignment: .leading)
              .animation(.easeInOut(duration: 3).repeatForever(autoreverses: false), value: drawingWidth)
          }
          .frame(width: 48, height: 13)
          .onAppear {
            drawingWidth.toggle()
          }.padding(.trailing, 2)
          Rectangle.pending.padding(.trailing, 2)
          Rectangle.pending
        }
         .padding(.bottom, 30)
        
        Text("Confirm and Pay").font(.medMedLarge)
        
        VStack {
          HStack {
            Text("Seller Venmo:").font(.regLarge).frame(maxWidth: .infinity, alignment: .leading)
            Text(listing.seller.venmoHandle).font(.regLarge).frame(maxWidth: .infinity, alignment: .trailing)
          }.padding(.bottom, 5)
          HStack {
            Text("Price per block:").font(.regLarge).frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "$%.2f", listing.price)).font(.regLarge).frame(maxWidth: .infinity, alignment: .trailing)
          }.padding(.bottom, 5)
          HStack {
            Text("Quantity:").font(.regLarge).frame(maxWidth: .infinity, alignment: .leading)
            Text("1x").font(.regLarge).frame(maxWidth: .infinity, alignment: .trailing)
          }.padding(.bottom, 5)
          Divider().frame(height: 15)
          HStack {
            Text("Total").font(.regLarge).frame(maxWidth: .infinity, alignment: .leading)
            Text(String(format: "$%.2f", listing.price)).font(.regLarge).frame(maxWidth: .infinity, alignment: .trailing)
          }
        }.frame(width: 352)
          .padding(.bottom, 80)
          .padding(.top, 40)
        
        
        Button(action: {
          listing.buyerStatus = BuyerStatus.completedPayment
          
          if listing.sellerStatus == SellerStatus.paymentRecieved {
            listing.completedTime = Date.now
          }
          
          if !listingRepository.update(listing: listing) {
            alertMsg = "Error updating this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("I Have Paid").font(.medSmall)
        }.buttonStyle(RedButton())
          .padding(.bottom, 20)
        
        Button(action: {
          showAlert = true
          alertMsg = "Are you sure you want to cancel this order?"
        }) {
          Text("Cancel").font(.medSmall)
        }.buttonStyle(WhiteButton())
      }
    }  }
}

