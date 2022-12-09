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
  @State var showEditListingView = false
  @State var showPurchaseView = false
  @State var showFilterView = false
  @State var showSortView = false
  @State var selectedListing: Listing? = nil
  @State var selectedListingProfile: UIImage? = nil
  @State var showErrorAlert = false
  @State private var alertMsg = ""
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
    var body: some View {
      GeometryReader { geometry in
        ZStack {
          Color("BlockMe Background").ignoresSafeArea().onReceive(timer) { time in
            currentTime = Date.now
            calendar = Calendar.current
          }
          ScrollView(showsIndicators: false) {
            Text("Marketplace").font(.medLarge).padding(.top, 20).padding(.bottom, 5)
            
            HStack {
              Button(action:{
                showFilterView.toggle()
              }){
                HStack {
                  Image("filter")
                    .resizable()
                    .frame(width: 15, height: 15)
                  Text("Filter").font(.regSmall)
                }
              }
              .buttonStyle(TinyBlackButton())
              .sheet(isPresented: $showFilterView) {
                FilterListingView(listingRepository: listingRepository, show: $showFilterView, priceRange: listingRepository.priceRange[1] == -1 ? [0.0, listingRepository.findMaxPrice()] : listingRepository.priceRange, expirationTimeMin: listingRepository.expirationTimeMin, expirationTimeMax: listingRepository.expirationTimeMax, locations: DiningLocation.allCases.map{listingRepository.locations.contains($0) ? ($0, true) : ($0, false)}, rating: listingRepository.rating)
              }
              
              Button(action:{
                showSortView.toggle()
              }){
                HStack {
                  Image("sort")
                    .resizable()
                    .frame(width: 15, height: 15)
                  Text("Sort").font(.regSmall)
                }
              }
              .buttonStyle(TinyBlackButton())
              .sheet(isPresented: $showSortView) {
                SortListingView(listingRepository: listingRepository)
                  .presentationDetents([.fraction(0.50)])
              }
            }.frame(width: 332, alignment: .trailing)
                                                                           
            VStack {
              // empty marketplace - notify users that there's no listing
              if listingRepository.currentListings.isEmpty {
                Image("no-result").resizable().scaledToFit().padding(.bottom, -20)
                  .padding(.top, 20)
                Text("THE MARKETPLACE IS CURRENTLY EMPTY").font(.medSmall).multilineTextAlignment(.center).frame(width: 332).padding(.bottom, 3)
                Text("Check back again later or tap the button below to create a listing").font(.regSmall).foregroundColor(Color(UIColor.darkGray)).multilineTextAlignment(.center).frame(width: 302)
              }
              
              // no listing match filter
              else if listingRepository.filteredListings.isEmpty {
                Image("not-found").resizable().scaledToFit()
                  .padding(.top, 15).padding(.bottom, -60)
                Text("YOUR FILTERS PRODUCED NO LISTINGS").font(.medSmall).multilineTextAlignment(.center).frame(width: 302).padding(.bottom, 3)
                Text("Try adjusting or resetting your filters to display listings").font(.regSmall).foregroundColor(Color(UIColor.darkGray)).multilineTextAlignment(.center).frame(width: 302)
              }
              
              // check if user has an active anf filtered listing
              // yes --> show 'your listing', and then show 'other's listing' if its present
              else if appViewModel.currentUserId != nil && listingRepository.getCurrentListingForSeller(uid: appViewModel.currentUserId!) != nil && listingRepository.getFilteredListingForSeller(uid: appViewModel.currentUserId!) != nil {
                Text("Your Listing").font(.medSmall).frame(width: 332, alignment: .leading);
                let listing = listingRepository.getCurrentListingForSeller(uid: appViewModel.currentUserId!)!
                Button(action:{
                  if appViewModel.currentUserId == listing.seller.id {
                    selectedListing = listing
                    showEditListingView.toggle()
                    return
                  }
                  
                  if appViewModel.currentUserId != nil && appViewModel.currentUserId != listing.seller.id && listingRepository.getCurrentListingForSeller(uid: appViewModel.currentUserId!) != nil {
                    alertMsg = "You cannot purchase a listing when you have an active listing."
                    showErrorAlert = true
                    return
                  }
                  
                  showPurchaseView.toggle()
                  showEditListingView = false
                  selectedListing = listing
                  StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) {image in selectedListingProfile = image}
                }){
                  ListingDetailsView(listing: listing, viewWidth: geometry.size.width).padding(.bottom, 40)
                }
                if !listingRepository.getFilteredListingWithoutSeller(uid: appViewModel.currentUserId!).isEmpty {
                  Text("Other's Listing").font(.medSmall).frame(width: 332, alignment: .leading);
                  ForEach(listingRepository.getFilteredListingWithoutSeller(uid: appViewModel.currentUserId!)) { listing in
                    Button(action:{
                      if appViewModel.currentUserId == listing.seller.id {
                        selectedListing = listing
                        showEditListingView.toggle()
                        return
                      }
                      
                      if appViewModel.currentUserId != nil && appViewModel.currentUserId != listing.seller.id && listingRepository.getCurrentListingForSeller(uid: appViewModel.currentUserId!) != nil {
                        alertMsg = "You cannot purchase a listing when you have an active listing."
                        showErrorAlert = true
                        return
                      }
                      
                      showPurchaseView.toggle()
                      showEditListingView = false
                      selectedListing = listing
                      StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) {image in selectedListingProfile = image}
                    }){
                      ListingDetailsView(listing: listing, viewWidth: geometry.size.width)
                    }
                  }
                }
              }
              
              // no --> show default listing view
              else {
                // lets add the title if the user has a listing up but doesn't match the filter 
                if appViewModel.currentUserId != nil && listingRepository.getCurrentListingForSeller(uid: appViewModel.currentUserId!) != nil {
                  Text("Other's Listing").font(.medSmall).frame(width: 332, alignment: .leading);
                }
                ForEach(listingRepository.filteredListings) { listing in
                  Button(action:{
                    if appViewModel.currentUserId == listing.seller.id {
                      selectedListing = listing
                      showEditListingView.toggle()
                      return
                    }
                    
                    if appViewModel.currentUserId != nil && appViewModel.currentUserId != listing.seller.id && listingRepository.getCurrentListingForSeller(uid: appViewModel.currentUserId!) != nil {
                      alertMsg = "You cannot purchase a listing when you have an active listing."
                      showErrorAlert = true
                      return
                    }
                    
                    showPurchaseView.toggle()
                    showEditListingView = false
                    selectedListing = listing
                    StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) {image in selectedListingProfile = image}
                  }){
                    ListingDetailsView(listing: listing, viewWidth: geometry.size.width)
                  }
                }
              }
              }
            }
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
                }.position(x: geometry.size.width - 70, y: geometry.size.height - 50)
              }
              else {
                Button(action: {
                  alertMsg = "You can only have one active listing at a time."
                  showErrorAlert = true
                }) {
                  Image("add-button-disabled")
                    .resizable()
                    .frame(width: 80, height: 80)
                }
                .position(x: geometry.size.width - 70, y: geometry.size.height - 50)
              }
            }
          }
          PurchaseListingView(show: $showPurchaseView, listing: $selectedListing, profileImage: $selectedListingProfile, listingRepository: listingRepository)
          NewListingView(show: $showNewListingView, listingRepository: listingRepository)
          EditListingView(show: $showEditListingView, selectedListing: $selectedListing, listingRepository: listingRepository)
        }
        .frame(maxHeight: .infinity)
        .alert(alertMsg, isPresented: $showErrorAlert) {
          Button("Ok", role: .cancel) {
            showErrorAlert = false
          }
        }
      }
    }
