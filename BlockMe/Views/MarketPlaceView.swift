//
//  MarketPlaceView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import SwiftUI

struct MarketPlaceView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @ObservedObject var listingRepository: ListingRepository = ListingRepository()
  @State var currentTime = Date.now
  @State var showNewListingView = false
  @State var showPurchaseView = false
  @State var selectedListing: Listing? = nil
  @State var selectedListingProfile: UIImage? = nil

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 

    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea().onReceive(timer) { time in
          currentTime = Date.now
        }
        VStack {
          Text("Blocks Marketplace").font(.title)
          // TODO: need to center the listings
          GeometryReader { geometry in
            let currentListings = listingRepository.listings.filter {
              $0.buyer == nil && $0.expirationTime > currentTime
            }
            VStack(alignment: .center, spacing: 0) { //TODO: the alignment center thingy no work
              ForEach(currentListings) { listing in
                Button(action:{
                    guard appViewModel.currentUserId != listing.seller.id else {
                      print("Can't purchase your own block.")
                      return
                    }
                  showPurchaseView.toggle()
                  selectedListing = listing
                  StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) {image in selectedListingProfile = image}
                }){
                  ListingDetailsView(listing: listing, viewWidth: geometry.size.width)
                }
              }
            }
          }
    
          HStack {
            Spacer()
            ZStack {
              if listingRepository.getCurrentListingForSeller(uid: appViewModel.currentUserId!) == nil {
                Button(action:{
                  showNewListingView.toggle()
                  appViewModel.tabsDisabled.toggle()
                }) {
                  Text("+") //TODO: switch this with a image of the plus icon
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color.black)
                    .background(Color("BlockMe Red"))
                    .clipShape(Circle())
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
              }
            }
          }
        }
        PurchaseListingView(show: $showPurchaseView, listing: $selectedListing, profileImage: $selectedListingProfile, listingRepository: listingRepository)
        NewListingView(show: $showNewListingView, listingRepository: listingRepository)
      }
    }
}
