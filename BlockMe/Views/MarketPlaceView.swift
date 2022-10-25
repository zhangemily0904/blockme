//
//  MarketPlaceView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import SwiftUI

struct MarketPlaceView: View {
  @ObservedObject var listingRepository: ListingRepository = ListingRepository()
  
    var body: some View {
      VStack {
        Text("Blocks Marketplace").font(.title)
        GeometryReader { geometry in
          List {
            ForEach(listingRepository.listings) { listing in
              ListingDetailsView(listing: listing, viewWidth: geometry.size.width)
            }
          }
        }
      }
    }
}

struct MarketPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketPlaceView()
    }
}
