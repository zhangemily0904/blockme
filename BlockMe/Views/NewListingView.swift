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
          Text(title).font(.medMed).frame(width: 296).padding(.top, 30)
          DatePicker("Expiration Time", selection: $expirationTime, displayedComponents: .hourAndMinute)
            .padding()
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .font(.medSmall)
            .frame(width: 296)
            .padding (.bottom, 15)
          HStack {
            Text("Price").font(.medSmall).frame(width: 166, alignment: .leading)
            TextField("Amount", value: $price, format: .currency(code: "USD"))
              .padding(5)
              .padding(.leading, 10)
              .frame(width: 90, alignment: .trailing)
              .autocapitalization(.none)
              .disableAutocorrection(true)
              .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous).fill(Color("IOS Grey"))
              )
          }.frame(width: 296)
            .padding (.bottom, 25)
          HStack {
            Text("Location").font(.medSmall).frame(width: 100, alignment: .leading).offset(y: -68)
            VStack (alignment: .leading, spacing: 10) {
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
                        Text(locations[i].0.rawValue).font(.regMed)
                          .foregroundColor(.black)
                      }
                    }
                  }
                }
            }
          }

          Button(action:{
            guard let seller = appViewModel.userViewModel?.user else {
              error = "error getting user information"
              showErrorAlert = true
              return
            }
            let listingSeller = ListingUser(id: seller.id, firstName: seller.firstName, lastName: seller.lastName, venmoHandle: seller.venmoHandle, phoneNumber: seller.phoneNumber, profileImageURL: seller.profileImageURL, rating: seller.getAvgRating())
            
            var availableLocations: [DiningLocation] = []
            for location in locations{
              if location.1 {
                availableLocations.append(location.0)
              }
            }
            
            let (isValidParameters, errorMsg) = FormValidator.isNewListingValid(expirationTime: expirationTime, price: price, availableLocations: availableLocations)
            
            guard isValidParameters else {
              error = errorMsg
              showErrorAlert = true
              return
            }
            
            // nil fields not showing up in firebase
            let newListing = Listing(seller: listingSeller, buyer: nil, price: price, expirationTime: expirationTime, completedTime: nil, availableLocations: availableLocations, buyerStatus: nil, sellerStatus: nil)
            listingRepository.add(listing: newListing)
            
            show = false
          }){
            Text("Sell").font(.medSmall)
          }.buttonStyle(SmallRedButton())
            .padding(.top, 40)
            .padding(.bottom, 15)
      
          Button("Cancel", role: .cancel) {
            show = false
            appViewModel.tabsDisabled.toggle()
            self.restoreFormToDefaults()
          }.buttonStyle(SmallWhiteButton())
            .font(.medSmall)
        }
        .padding(.bottom, 30)
        .frame(width: 347)
        .background(Color.white)
        .cornerRadius(16)
  
      }
    }.onAppear {
      guard locations.count < 1 else {
        return
      }
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

