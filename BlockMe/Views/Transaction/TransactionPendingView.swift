//
//  TransactionPendingView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/8/22.
//

import SwiftUI

struct TransactionPendingView: View {
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
      }
      else {
        self.buyerContent
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
          alertMsg = "Are you sure you want to decline this order?"
          showAlert = true
        }) {
          Text("Decline")
        }.buttonStyle(SmallWhiteButton())
      }
    }
  }
  
  var buyerContent: some View {
    VStack {
      if let listing = listingViewModel.listing {
        
        HStack {
          ZStack(alignment: .leading) {
            Rectangle.pending
            Rectangle()
              .fill(Color("BlockMe Red"))
              .frame(width: drawingWidth ? 55 : 0, alignment: .leading)
              .animation(.easeInOut(duration: 3).repeatForever(autoreverses: false), value: drawingWidth)
          }
          .frame(width: 56, height: 13)
          .onAppear {
            drawingWidth.toggle()
          }.padding(.trailing, 6)
          Rectangle.pending.padding(.trailing, 6)
          Rectangle.pending.padding(.trailing, 6)
          Rectangle.pending.padding(.trailing, 6)
          Rectangle.pending
        }.padding(.bottom, 20)
        
        Text("Waiting for \(listing.seller.firstName) to accept order").font(.medLarge).padding(.bottom, 50)
        Image("waiting").resizable().scaledToFit().padding(.bottom, 58)
        
        Button(action: {
          showAlert = true
          alertMsg = "Are you sure you want to cancel this order?"
        }) {
          Text("Cancel")
        }.buttonStyle(WhiteButton())
      }
    }.frame(width: 352)
  }
}
