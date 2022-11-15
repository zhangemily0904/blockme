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
          Text("Orders").font(.medLarge).padding(.top, 20).padding(.bottom, 5)
          GeometryReader { geometry in
            if let userId = appViewModel.currentUserId{
              let currentListings = listingRepository.listings.filter {
                ($0.seller.id == userId || $0.buyer?.id == userId) && $0.completedTime != nil
              }
        
              ScrollView(showsIndicators: false) {
                ForEach(currentListings.sorted { $0.completedTime! > $1.completedTime! }) { listing in
                  OrderDetailsView(order: listing, viewWidth: geometry.size.width, seller: listing.seller.id==userId)
                }
              }.frame(width: geometry.size.width, alignment: .center)
            }
          }
        }
      }
    }
}

