//
//  PurchaseFormView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/6/22.
//

import SwiftUI

struct PurchaseListingView: View {
  @Binding var show: Bool
  @Binding var listing: Listing? 
  @Binding var profileImage: UIImage?
  @State var showErrorAlert = false
  @State private var alertMsg = ""
  @State var expand = false
  
  @State var selectedLocation: DiningLocation? = nil
  @ObservedObject var listingRepository: ListingRepository
  @EnvironmentObject var appViewModel: AppViewModel
  
  func getFormattedDate(date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, y, HH:mm"
    return dateFormatter.string(from: date)
  }
  
  var body: some View {
    ZStack {
      if show {
        // semi-transparent background and popup window
        Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
        
        VStack(alignment: .center, spacing: 0) {
          
          if let listing = listing {
            if let profileImage = profileImage {
              Image(uiImage: profileImage)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            }
            Text("Seller: \(listing.seller.firstName)")
            Text("Price: \(String(listing.price))")
            Text("Expiration Date: \(getFormattedDate(date: listing.expirationTime))")
            
            // dropdown
            VStack(alignment: .leading, spacing: 20){
              HStack {
                Text("Locations")
                  .fontWeight(.bold)
                Image(systemName: "chevron.down")
              }.onTapGesture{
                self.expand.toggle()
              }
              if expand {
                ForEach(0..<listing.availableLocations.count) { i in
                  HStack {
                    Button(action: {
                      selectedLocation = listing.availableLocations[i]
                    }) {
                      HStack{
                        if selectedLocation == listing.availableLocations[i] {
                          Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        }
                        Text(listing.availableLocations[i].rawValue)
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
          
          }
          
          Button(action: {
            if var listing = listing {
              guard let user = appViewModel.userViewModel?.user else {
                alertMsg = "error getting user information"
                showErrorAlert = true
                return
              }
              
              guard selectedLocation != nil else {
                alertMsg = "Must choose location to purchase the block."
                showErrorAlert = true
                return
              }
              
              let buyer = ListingUser(id: user.id, firstName: user.firstName, lastName: user.lastName, venmoHandle: user.venmoHandle, phoneNumber: user.phoneNumber, profileImageURL: user.profileImageURL)
              listing.buyer = buyer
              listing.selectedLocation = selectedLocation
              listing.buyerStatus = BuyerStatus.requested
              
              guard listingRepository.update(listing:listing) else {
                alertMsg = "There was an error updating the listing. Please try again later."
                showErrorAlert = true
                return
              }
            }
            show = false
          }) {
            Text("buy")
              .bold()
              .frame(width: 200, height: 40)
              .foregroundColor(Color.white)
              .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("BlockMe Red"))
              )
          }

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
    }.alert(alertMsg, isPresented: $showErrorAlert) {
      Button("Ok", role: .cancel) {
        showErrorAlert = false
      }
    }
  }
  
  private func restoreFormToDefaults() {
    selectedLocation = nil
    expand = false
  }
}
