//
//  TransactionConfirmingView.swift
//  BlockMe
//
//  Created by Wen Shan Jiang on 11/13/22.
//

import SwiftUI

// generic waiting room for transactions
struct TransactionConfirmingView: View {
  @ObservedObject var listingRepository: ListingRepository
  @ObservedObject var listingViewModel: ListingViewModel
  var waitingFor: String
  var msgPostfix: String
  @State var showErrorAlert = false // alert for errors
  @State var showAlert = false // alert for confirming cancel / decline order
  @State private var alertMsg = ""
  @State private var drawingWidth = false
  
    var body: some View {
      VStack {
        if let listing = self.listingViewModel.listing {
          let name = (waitingFor == "seller") ? listing.seller.firstName : (listing.buyer?.firstName ?? "XXX")
          let image = (waitingFor == "seller") ? listingViewModel.sellerImage : listingViewModel.buyerImage
          let phoneNumber = (waitingFor == "seller") ?  String(listing.seller.phoneNumber) : String(listing.buyer?.phoneNumber ?? "(XXX) XXX - XXXX")
          
          HStack {
            Rectangle.completed.padding(.trailing, 2)
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
            Rectangle.pending
          }
           .padding(.bottom, 30)
          
          Text("Waiting for \(name) to \(msgPostfix) payment").font(.medMedLarge)
          if let image = image {
            Image(uiImage: image)
              .resizable()
              .frame(width: 200, height: 200)
              .clipShape(Circle())
              .padding(.bottom, 20)
              .padding(.top, 20)
          }
          
          HStack {
            Image("telephone").resizable().frame(width: 30, height: 30)
            Text(phoneNumber).font(.regMed)
          } .padding(.bottom, 30)
          
          Button(action: {
            alertMsg = "Are you sure you want to cancel this order?"
            showAlert = true
          }) {
            Text("Cancel").font(.medSmall)
          }.buttonStyle(WhiteButton())
        }
      }.alert(alertMsg, isPresented: $showErrorAlert) {
        Button("Ok", role: .cancel) {
          showErrorAlert = false
        }
      }
      .alert(alertMsg, isPresented: $showAlert) {
        Button("Yes", role: .destructive) {
          showErrorAlert = false
          if let listing = listingViewModel.listing {
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
