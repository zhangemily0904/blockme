//
//  ContentView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/23/22.
//

import SwiftUI

struct AppView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @ObservedObject var listingRepository: ListingRepository = ListingRepository()
  
    var body: some View {
      NavigationView {
        if appViewModel.signedIn {
          if let listing = listingRepository.getPendingListingForBuyer(uid: appViewModel.currentUserId!) {
            TransactionView(listingId: listing.id!, isSeller: false)
          }
          else if let listing = listingRepository.getPendingListingForSeller(uid: appViewModel.currentUserId!){
            TransactionView(listingId: listing.id!, isSeller: true)
          }
          else {
            TabView {
              MarketPlaceView()
                .tabItem {
                  Image(systemName: "house")
                  Text("Marketplace")
                }
              
              OrdersView()
                .tabItem {
                  Image(systemName: "bag.fill")
                  Text("Orders")
                }
              
              ProfileView()
                .tabItem {
                  Image(systemName: "person")
                  Text("Profile")
                }
            }
  //          .disabled(appViewModel.tabsDisabled)
          }
        } else {
          SplashView()
        }
      }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
