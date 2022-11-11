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
            HStack {
              if let profileImage = profileImage {
                Image(uiImage: profileImage)
                  .resizable()
                  .frame(width: 100, height: 100, alignment: .leading)
                  .clipShape(Circle())
              }
              VStack {
                Text("\(listing.seller.firstName)").font(.medMed)
              }.frame(width: 145, height: 100, alignment: .leading).padding(.leading, 20)
            }.padding(.top, 30)
            .frame (width: 347)
            
            let timeRemaining = ListingDetailsView.dateComponentFormatter.string(from: MarketPlaceView().currentTime, to: listing.expirationTime)!
            HStack {
              HStack {
                Image("dollar")
                  .resizable()
                  .frame(width: 40, height: 40)
                  .padding(.trailing, 5)
                Text(String(format: "$%.2f", listing.price)).font(.regSmall)
              }.frame(width: 115, height: 70)
                .background(Color("BlockMe Background").clipShape(RoundedRectangle(cornerRadius:15)))
              
              HStack {
                Image("wall-clock")
                  .resizable()
                  .frame(width: 40, height: 40)
                  .padding(.trailing, 5)
                Text("Expires in \(timeRemaining)").font(.regSmall)
              }.frame(width: 145, height: 70)
                .background(Color("BlockMe Background").clipShape(RoundedRectangle(cornerRadius:15)))
                
            }.padding(.bottom, 20)
             .padding(.top, 20)
             .frame(width: 270)
            
              
            VStack {
              Text("Where do you want to eat?").font(.medSmall).padding(.bottom, 1)
              VStack(alignment: .leading, spacing: 7){
                ForEach(0..<listing.availableLocations.count) { i in
                  HStack {
                    Button(action: {
                      selectedLocation = listing.availableLocations[i]
                    }) {
                      HStack{
                        if selectedLocation == listing.availableLocations[i] {
                          Image(systemName: "circle.fill")
                            .foregroundColor(.green)
                        } else {
                          Image(systemName: "circle")
                            .foregroundColor(.green)
                        }
                        Text(listing.availableLocations[i].rawValue).font(.regMed)
                          .foregroundColor(.black)
                      }
                    }
                  }.offset(x:-25)
                }
              }
            }.frame(width: 270, alignment: .leading)
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
            Text("Buy").font(.medSmall)
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
