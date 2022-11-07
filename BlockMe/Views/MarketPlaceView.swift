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
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @State var currentTime = Date.now
  @State var showListingForm = false
    var body: some View {
     
      NavigationView {
        ZStack {
          Color("BlockMe Background").ignoresSafeArea().onReceive(timer) { time in
            currentTime = Date.now
          }
          VStack {
            Text("Blocks Marketplace").font(.title)
            GeometryReader { geometry in
              let currentListings = listingRepository.listings.filter {
                $0.buyer == nil && $0.expirationTime > currentTime
              }
              ForEach(currentListings) { listing in
                ListingDetailsView(listing: listing, viewWidth: geometry.size.width)
              }
              
            }
            
            HStack {
              Spacer()
              ZStack {
                Button(action:{
                  showListingForm.toggle()
                }) {
                  Text("+") //TODO: switch this with a image of the plus icon
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color.black)
                    .background(Color.red)
                    .clipShape(Circle())
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
              }
            }
          }
          NewListingFormView(show: $showListingForm, listingRepository: listingRepository)

        }
      }
        
      
    }
}

struct MarketPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketPlaceView()
    }
}
