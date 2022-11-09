//
//  ListingDetailView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseStorage

struct ListingDetailsView: View {
  var listing: Listing
  var viewWidth: CGFloat
  @State var profileImage: UIImage? = nil
  
  var body: some View {
    HStack() {
      if let profileImage = profileImage {
        Image(uiImage: profileImage)
          .resizable()
          .frame(width: viewWidth / 6, height: viewWidth / 6) // dynamically scale size of profile image
          .clipShape(Circle())
      }
      VStack(alignment: .leading) {
        Text(listing.seller.firstName).font(.medSmall)
        HStack {
          let timeRemaining = ListingDetailsView.dateComponentFormatter.string(from: MarketPlaceView().currentTime, to: listing.expirationTime)!
          let min = MarketPlaceView().calendar.dateComponents([.minute], from: MarketPlaceView().currentTime, to: listing.expirationTime).minute!
          if min > 60 {
            Circle().fill(Color("Expiration Green")).frame(width: 8, height: 8)
            Text("Expires in \(timeRemaining)").font(.medTiny).foregroundColor(Color("Expiration Green"))
          } else if min > 30 {
            Circle().fill(Color("Expiration Yellow")).frame(width: 8, height: 8)
            Text("Expires in \(timeRemaining)").font(.medTiny).foregroundColor(Color("Expiration Yellow"))
          } else {
            Circle().fill(Color("Expiration Red")).frame(width: 8, height: 8)
            Text("Expires in \(timeRemaining)").font(.medTiny).foregroundColor(Color("Expiration Red"))
          }
        }
//        ForEach(0..<listing.availableLocations.count) { i in
//          Text(listing.availableLocations[i].rawValue)
//        }
      }
      Text(String(format: "$%.2f", listing.price)).font(.medMed)
    }.padding(15)
    .background(Color("BlockMe Yellow"))
    .foregroundColor(.black)
    .onAppear {
      StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) { image in
        profileImage = image
      }
    }
  }
  
  private static let dateComponentFormatter: DateComponentsFormatter = {
          var formatter = DateComponentsFormatter()
          formatter.allowedUnits = [.day, .hour, .minute]
          formatter.unitsStyle = .brief
          return formatter
      }()
}

