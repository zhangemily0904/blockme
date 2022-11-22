//
//  EditListingView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/21/22.
//

import SwiftUI

struct EditListingView: View {
  typealias LocationSelection = (DiningLocation, Bool)
  @Binding var show: Bool
  @State var listing: Listing
  @State var price: Float = 0.0
  @State var expirationTime: Date = Date.now
  @State var locations: [LocationSelection] = DiningLocation.allCases.map {($0, false)}

  @ObservedObject var listingRepository: ListingRepository
  @EnvironmentObject var appViewModel: AppViewModel
  @State var expand = false
  @State var showErrorAlert: Bool = false
  @State var showAlert: Bool = false
  @State var error: String = ""
  @State var alertMsg: String = ""

  var title: String = "Changed your mind? That’s okay"
  
  let formatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      return formatter
  }()
  
  var body: some View {
    ZStack {
      // semi-transparent background and popup window
      Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
      if show {
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
          
          Button("Delete") {
            alertMsg = "Are you sure you want to delete this listing?"
            showAlert = true
          }.buttonStyle(SmallRedButton())
            .font(.medSmall)
            .padding(.top, 40)
            .padding(.bottom, 15)

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
            listing.price = price
            listing.availableLocations = availableLocations
            listing.expirationTime = expirationTime

            guard listingRepository.update(listing: listing) else {
                error = "Unable to update listing"
                showErrorAlert = true
                return
            }
            show = false
          }){
            Text("Update").font(.medSmall)
          }.buttonStyle(SmallWhiteButton())
            
      
        }
        .padding(.bottom, 30)
        .frame(width: 347)
        .background(Color.white)
        .cornerRadius(16)
      }
      
    }.onAppear {
      expirationTime = listing.expirationTime
      price = listing.price
      locations = locations.map{listing.availableLocations.contains($0.0) ? ($0.0, true) : $0}
    }
    .alert(error, isPresented: $showErrorAlert) {
      Button("Ok", role: .cancel) {
        showErrorAlert = false
      }
    }
    .alert(alertMsg, isPresented: $showAlert) {
      Button("Yes", role: .destructive) {
        showAlert = false
        listingRepository.delete(listing: listing)
        show = false
      }
      Button("No", role: .cancel) {
        showAlert = false
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

