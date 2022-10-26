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
    HStack {
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
      }
    }.onAppear {
      retrieveProfileImage()
    }
  }
  
  func retrieveProfileImage() {
    let storageRef = Storage.storage().reference()
    let fileRef = storageRef.child(listing.seller.profileImageURL)
    
    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
      if error == nil && data != nil {
        profileImage = UIImage(data: data!)
        return
      }
      
      print("Error fetching image of path \(listing.seller.profileImageURL)")
    }
  }
}

