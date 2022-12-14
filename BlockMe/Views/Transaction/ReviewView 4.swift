//
//  ReviewView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/20/22.
//

import SwiftUI

struct ReviewView: View {
  @ObservedObject var listingRepository: ListingRepository
  @ObservedObject var listingViewModel: ListingViewModel
  var isSeller: Bool
  @State var alertMsg = ""
  @State var showErrorAlert = false // alert for errors
  @State private var drawingWidth = false
  @State var numStars = 0
  
  var body: some View {
    VStack {
      if var listing = listingViewModel.listing {
        let name = self.isSeller ? (listing.buyer?.firstName ?? "XXX") : listing.seller.firstName
        let image = self.isSeller ? listingViewModel.buyerImage : listingViewModel.sellerImage
        
        HStack {
          Rectangle.completed.padding(.trailing, 2)
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
          }
        }
         .padding(.bottom, 30)
        
        Text("Rate Your Transaction").font(.medMedLarge)
        if let image = image {
          Image(uiImage: image)
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .padding(.bottom, -25)
            .padding(.top, 20)
        }
        
        Text(name)
          .font(.medMed)
          .padding()
          .frame(width: (CGFloat(name.count) * 15) + 30, height: 40)
          .foregroundColor(Color.white)
          .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.black))
          
        StarRatingComponent(rating: $numStars).padding(.bottom, 50).padding(.top, 50)
        
        Button(action: {
          if self.isSeller {
            listing.sellerStatus = SellerStatus.reviewed
          } else {
            listing.buyerStatus = BuyerStatus.reviewed
          }
          
          if !listingRepository.update(listing: listing) {
            alertMsg = "Error updating this order. Please try again."
            showErrorAlert = true
          }
          
          // async update ratings for user
          DispatchQueue.main.async {
            let userId = isSeller ? (listing.buyer?.id ?? "") : listing.seller.id ?? ""
            print("USERID FOR REVIEW: \(userId)")
            UserViewModel.addRating(userId: userId, rating: numStars)
          }
        }) {
          Text("Submit").font(.medSmall)
        }.buttonStyle(RedButton())
          .padding(.bottom, 20)
        
        Button(action: {
          if self.isSeller {
            listing.sellerStatus = SellerStatus.reviewed
          } else {
            listing.buyerStatus = BuyerStatus.reviewed
          }
          
          if !listingRepository.update(listing: listing) {
            alertMsg = "Error updating this order. Please try again."
            showErrorAlert = true
          }
        }) {
          Text("Skip").font(.medSmall)
        }.buttonStyle(WhiteButton())
      }
    }.frame(width: 352)
    .alert(alertMsg, isPresented: $showErrorAlert) {
      Button("Ok", role: .cancel) {
        showErrorAlert = false
      }
    }
  }
}
