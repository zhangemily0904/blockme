//
//  PurchaseFormView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/6/22.
//

import SwiftUI

struct PurchaseListingView: View {
  typealias LocationSelection = (DiningLocation, Bool)
  @Binding var show: Bool
  @Binding var listing: Listing?
  @State var showErrorAlert = false
  @State private var alertMsg = ""
  @State var profileImage: UIImage? = nil

  @State var selectedLocation: DiningLocation? = nil
  @ObservedObject var listingRepository: ListingRepository
  @EnvironmentObject var appViewModel: AppViewModel
  var viewWidth:CGFloat = 347

  
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
                .frame(width: viewWidth / 5, height: viewWidth / 5) // dynamically scale size of profile image
                .clipShape(Circle())
            }
            Text("Seller:\(listing.seller.firstName)")
            Text("Price: \(String(listing.price))")
            Text("Expiration Date: \(DateFormatter().string(from: listing.expirationTime))")
            Menu {
              ForEach(0..<listing.availableLocations.count) { i in
                HStack {
                  Button(action: {
                    selectedLocation = listing.availableLocations[i]
                  }) {
                    HStack{
                      if listing.availableLocations[i].rawValue == selectedLocation?.rawValue ?? "" {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                      }
                      Text(listing.availableLocations[i].rawValue)
                    }
                  }
                  .buttonStyle(BorderlessButtonStyle())
                }
                
              }
            } label: {
              Label(title: {Text("\(selectedLocation?.rawValue ?? "Locations")")},
                    icon: {Image(systemName: "plus")})
            }
            
          }
          NavigationLink(destination: TransactionView()) {
            Text("Buy")
              .bold()
              .frame(width: 200, height: 40)
              .foregroundColor(Color.white)
              .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("BlockMe Red"))
              )
          }
          .simultaneousGesture(TapGesture().onEnded{
            show = false
            //TODO: set buyer and seller status
            if var listing = listing {
              guard let user = appViewModel.userViewModel?.user else {
                // TODO: Replace with alert
                print("error getting user information")
                return
              }
              let buyer = ListingUser(firstName: user.firstName, lastName: user.lastName, venmoHandle: user.venmoHandle, phoneNumber: user.phoneNumber, profileImageURL: user.profileImageURL)
              listing.buyer = buyer
              
              guard listingRepository.update(listing:listing) else {
                alertMsg = "There was an error updating the listing. Please try again later."
                showErrorAlert = true
                return
              }
            }
          })
          .alert(alertMsg, isPresented: $showErrorAlert) {
            Button("Ok", role: .cancel) {
              showErrorAlert = false
            }
          }
          Button("Cancel", role: .cancel) {
            show = false
            appViewModel.tabsDisabled.toggle()
          }.buttonStyle(WhiteButton())
        }
        
        .frame(width: 347, height: 585)
        .background(Color.white)
        .cornerRadius(16)
        
  
      }
    }
    .onAppear {
      if let listing = listing {
        StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) { image in
          profileImage = image
        }
      
      
      }
    }
  }
}
