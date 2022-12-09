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
  @Binding var selectedListing: Listing?
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

  var title: String = "Changed your mind? That is okay"
  
  let formatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      return formatter
  }()
  
  var body: some View {
    ZStack {
      // semi-transparent background and popup window
      Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
      if var listing = selectedListing {
        if show {
          VStack(alignment: .center, spacing: 0) {
            Button(action: {
              show = false
            }){
              Image("cancel")
                .resizable()
                .frame(width: 30, height: 30)
            }
            .frame(width: 296, alignment: .trailing)
            .padding(.top, 30)
            .padding(.bottom, 10)
            
            Text(title).font(.medMed).frame(width: 296)

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
                            .foregroundColor(Color("BlockMe Red"))
                        } else {
                          Image(systemName: "checkmark.circle")
                            .foregroundColor(Color("BlockMe Red"))
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
              selectedListing = nil
              show = false
            }){
              Text("Update")
            }.buttonStyle(SmallRedButton())
              .font(.medSmall)
              .padding(.top, 40)
              .padding(.bottom, 15)
            
            Button("Delete") {
              alertMsg = "Are you sure you want to delete this listing?"
              showAlert = true
            }.buttonStyle(SmallWhiteButton())
              .font(.medSmall)
          }
          .padding(.bottom, 30)
          .frame(width: 347)
          .background(Color.white)
          .cornerRadius(16)
        }
      }
    }.onChange(of: show) { _ in
      locations = DiningLocation.allCases.map {($0, false)}
      if var listing = selectedListing {
        expirationTime = listing.expirationTime
        price = listing.price
        locations = locations.map{listing.availableLocations.contains($0.0) ? ($0.0, true) : $0}
      }
    }
    .alert(error, isPresented: $showErrorAlert) {
      Button("Ok", role: .cancel) {
        showErrorAlert = false
      }
    }
    .alert(alertMsg, isPresented: $showAlert) {
      Button("Yes", role: .destructive) {
        showAlert = false
        guard let listing = selectedListing else {
          error = "listing is null"
          showErrorAlert = true
          return
        }
        listingRepository.delete(listing: listing) { errorMsg in
          if let msg = errorMsg {
            error = msg
            showErrorAlert = true
          } else {
            selectedListing = nil
            show = false
          }
        }
      }
      Button("No", role: .cancel) {
        showAlert = false
      }
    }
    .onTapGesture {
      self.hideKeyboard()
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

