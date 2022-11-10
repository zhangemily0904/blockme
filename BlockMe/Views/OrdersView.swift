//
//  OrdersView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/2/22.
//

import SwiftUI

struct OrdersView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @ObservedObject var listingRepository: ListingRepository = ListingRepository()
  var seller = false
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        VStack {
          Text("Orders").font(.title)
          // TODO: need to center the listings
          GeometryReader { geometry in
            if let userId = appViewModel.currentUserId{
              let currentListings = listingRepository.listings.filter {
                ($0.seller.id == userId || $0.buyer?.id == userId) && $0.completedTime != nil
              }
        
              VStack {
                ForEach(currentListings) { listing in
                 
                  OrderDetailsView(order: listing, viewWidth: geometry.size.width, seller: listing.seller.id==userId)
                }
              }
            }
          }
        }
      }
    }
}

