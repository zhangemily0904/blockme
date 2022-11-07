//
//  NewListingFormView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/6/22.
//

import SwiftUI

struct NewListingView: View {
  typealias LocationSelection = (DiningLocation, Bool)
  @Binding var show: Bool
  @State var expirationTime: Date = Date.now
  @State var price: Float = 0.0
  @State var locations: [LocationSelection] = []
  @ObservedObject var listingRepository: ListingRepository
  @EnvironmentObject var appViewModel: AppViewModel
  @State var expand = false

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
          VStack(alignment: .leading, spacing: 20){
              HStack {
                Text("Locations")
                  .fontWeight(.bold)
                Image(systemName: "chevron.down")
              }.onTapGesture{
                self.expand.toggle()
              }
              if expand {
                ForEach(0..<locations.count) { i in
                  HStack {
                    Button(action: {
                      locations[i].1 = locations[i].1 ? false : true
                    }) {
                      HStack{
                        if locations[i].1 {
                          Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        } else {
                          Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                        }
                        Text(locations[i].0.rawValue)
                          .foregroundColor(.black)
                      }
                    }
                  }
                }
              }
            }
            .frame(width: 289)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(.black)
            )

          //TODO: checks if fields are filled
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
            // nil fields not showing up in firebase
            let newListing = Listing(seller: listingSeller, buyer: nil, price: price, expirationTime: expirationTime, completedTime: nil, availableLocations: availableLocations, buyerStatus: nil, sellerStatus: nil)
            listingRepository.add(listing: newListing)
            
            show = false
          }){
            Text("Sell")
          }.buttonStyle(SmallRedButton())
      
          Button("Cancel", role: .cancel) {
            show = false
            appViewModel.tabsDisabled.toggle()
          }.buttonStyle(SmallWhiteButton())
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

