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
  @State var calendar = Calendar.current
  @State var showNewListingView = false
  @State var showPurchaseView = false
  @State var showFilterView = false
  @State var showSortView = false
  @State var selectedListing: Listing? = nil
  @State var selectedListingProfile: UIImage? = nil
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea().onReceive(timer) { time in
          currentTime = Date.now
          calendar = Calendar.current
        }
        VStack {
          Text("Marketplace").font(.medLarge).padding(.top, 20).padding(.bottom, 5)
          
          HStack {
            Button(action:{
              showFilterView.toggle()
            }){
              Text("Filter")
            }
            .sheet(isPresented: $showFilterView) {
              FilterListingView(listingRepository: listingRepository, show: $showFilterView, priceRange: listingRepository.priceRange[1] == -1 ? [0.0, listingRepository.findMaxPrice()] : listingRepository.priceRange, expirationTimeMin: listingRepository.expirationTimeMin, expirationTimeMax: listingRepository.expirationTimeMax, locations: DiningLocation.allCases.map{listingRepository.locations.contains($0) ? ($0, true) : ($0, false)})
            }
            
            Button(action:{
              showSortView.toggle()
            }){
              Text("Sort")
            }
          }
          
          GeometryReader { geometry in
            let currentListings = listingRepository.filteredListings
            ScrollView(showsIndicators: false) {
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
                  ListingDetailsView(listing: listing, viewWidth: 432)
                }
              }
            }.frame(width: geometry.size.width, alignment: .center)
          }
    
          HStack {
            Spacer()
            ZStack {
              if appViewModel.currentUserId != nil && listingRepository.getCurrentListingForSeller(uid: appViewModel.currentUserId!) == nil {
                Button(action:{
                  showNewListingView.toggle()
                  appViewModel.tabsDisabled.toggle()
                }) {
                  Image("add-button")
                    .resizable()
                    .frame(width: 60, height: 60)
                }.offset(x: -25, y: -30)
              }
            }
          }
        }
        PurchaseListingView(show: $showPurchaseView, listing: $selectedListing, profileImage: $selectedListingProfile, listingRepository: listingRepository)
        NewListingView(show: $showNewListingView, listingRepository: listingRepository)

      }
      .frame(maxHeight: .infinity)
    }
}
