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
  @State var showErrorAlert: Bool = false
  @State var error: String = ""
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
          Text(title).font(.medMed).frame(width: 296)
          DatePicker("Expiration Time", selection: $expirationTime, displayedComponents: .hourAndMinute)
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .font(.medSmall)
            .frame(width: 296)
          TextField("Price", value: $price, formatter: formatter)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .frame(width: 296)
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

          Button(action:{
            guard let seller = appViewModel.userViewModel?.user else {
              error = "error getting user information"
              showErrorAlert = true
              return
            }
            let listingSeller = ListingUser(id: seller.id, firstName: seller.firstName, lastName: seller.lastName, venmoHandle: seller.venmoHandle, phoneNumber: seller.phoneNumber, profileImageURL: seller.profileImageURL)
            
            var availableLocations: [DiningLocation] = []
            for location in locations{
              if location.1 {
                availableLocations.append(location.0)
              }
            }
            
            guard availableLocations.count > 0 else {
              error = "Must provide at least 1 available location."
              showErrorAlert = true
              return
            }
            
            guard expirationTime > Date.now else {
              error = "Expiration time must be in the future."
              showErrorAlert = true
              return
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
            self.restoreFormToDefaults()
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
    .alert(error, isPresented: $showErrorAlert) {
      Button("Ok", role: .cancel) {
        showErrorAlert = false
      }
    }
  }
  
  private func restoreFormToDefaults() {
    expirationTime = Date.now
    price = 0.0
    locations = []
    for location in DiningLocation.allCases {
      locations.append((location, false))
    }
    expand = false
  }
}

