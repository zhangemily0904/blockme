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
          .frame(width: viewWidth / 5, height: viewWidth / 5) // dynamically scale size of profile image
          .clipShape(Circle())
      }
      VStack(alignment: .leading) {
        Text(listing.seller.firstName).bold()
        Text(String(format: "$%.2f", listing.price))
        Text("Expires at \(listing.expirationTime)")
        ForEach(0..<listing.availableLocations.count) { i in
          Text(listing.availableLocations[i].rawValue)
        }
      }
    }
    .background(Color("BlockMe Yellow"))
    .frame(width: 332, height: 121)
    .foregroundColor(.black)
    .onAppear {
      StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) { image in
        profileImage = image
      }
    }
  }
}

