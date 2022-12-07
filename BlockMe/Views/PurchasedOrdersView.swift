//
//  OrdersView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/2/22.
//

import SwiftUI

struct PurchasedOrdersView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @ObservedObject var listingRepository: ListingRepository = ListingRepository()
  var seller = false
  
    var body: some View {
      GeometryReader { geometry in
        ZStack {
          Color("BlockMe Background").ignoresSafeArea()
          ScrollView(showsIndicators: false) {
            
            if let userId = appViewModel.currentUserId{
              let purchasedListings = listingRepository.listings.filter {
                ($0.buyer?.id == userId) && $0.completedTime != nil
              }
        
              VStack {
                ForEach(purchasedListings.sorted { $0.completedTime! > $1.completedTime! }) { listing in
                  OrderDetailsView(order: listing, viewWidth: geometry.size.width, seller: listing.seller.id==userId)
                    .padding(.top, 20)
                }
              }.frame(width: geometry.size.width, alignment: .center)
            }
          }
        }
      }
    }
}

