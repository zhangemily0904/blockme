//
//  NewListingFormView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/6/22.
//

import SwiftUI

struct NewListingFormView: View {
  typealias LocationSelection = (DiningLocation, Bool)
  @Binding var show: Bool
  @State var expirationTime: Date = Date.now
  @State var price: Float = 0.0
  @State var locations: [LocationSelection] = []
  @ObservedObject var listingRepository: ListingRepository
  @EnvironmentObject var appViewModel: AppViewModel
  
  var title: String = "Start selling blocks it's easy and free"
  
  let formatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      return formatter
  }()
  
  var body: some View {
    ZStack {
      if show {
        // semi-transparent background and popup window
        Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)

        VStack(alignment: .center, spacing: 0) {
          Text(title)
            .font(Font.system(size: 23, weight: .semibold))
          DatePicker("Expiration Time", selection: $expirationTime, displayedComponents: .hourAndMinute)
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(true)
          TextField("Price", value: $price, formatter: formatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(true)
          Menu {
            ForEach(0..<locations.count) { i in
              HStack {
                Button(action: {
                  locations[i].1 = locations[i].1 ? false : true
                }) {
                    HStack{
                      if locations[i].1 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .animation(.easeIn)
                      } else {
                          Image(systemName: "circle")
                              .foregroundColor(.primary)
                              .animation(.easeOut)
                      }
                      Text(locations[i].0.rawValue)
                    }
                }.buttonStyle(BorderlessButtonStyle())
              }
            }
          } label: {
            Label("Locations", systemImage: "plus")
          }
          Button(action:{
            guard let seller = appViewModel.userViewModel?.user else {
              // TODO: Replace with alert
              print("error getting user information")
              return
            }
            let listingSeller = ListingUser(firstName: seller.firstName, lastName: seller.lastName, venmoHandle: seller.venmoHandle, phoneNumber: seller.phoneNumber, profileImageURL: seller.profileImageURL)
            
            var availableLocations: [DiningLocation] = []
            for location in locations{
              if location.1 {
                availableLocations.append(location.0)
              }
            }
            
            let newListing = Listing(seller: listingSeller, price: price, expirationTime: expirationTime, availableLocations: availableLocations)
            listingRepository.add(listing: newListing)
          }){
            Text("Sell")
          }.buttonStyle(RedButton())
      
          Button("Cancel", role: .cancel) {
            show = false
          }.buttonStyle(WhiteButton())
        }
        
        .frame(width: 347, height: 585)
        .background(Color.white)
        .cornerRadius(16)
  
      }
    }.onAppear {
      for location in DiningLocation.allCases {
        locations.append((location, false))
      }
    }
  }
}
