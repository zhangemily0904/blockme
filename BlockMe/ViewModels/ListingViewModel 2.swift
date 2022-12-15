//
//  ListingViewModel.swift
//  BlockMe
//
//  Created by Brian Chou on 11/8/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class ListingViewModel: ObservableObject, Identifiable {
  @Published var listing: Listing? = nil
  @Published var buyerImage: UIImage? = nil
  @Published var sellerImage: UIImage? = nil
  
  var id: String
  private let path: String = "listings"
  private let store = Firestore.firestore()
  
  init(id: String) {
    self.id = id
    self.get()
  }
  
  // fetches listing data from firestore
  func get() {
    store.collection(path).document(self.id)
      .addSnapshotListener { documentSnapshot, error in
        if let error = error {
          print("Error getting listing info: \(error.localizedDescription)")
          return
        }
        
        guard let dc = documentSnapshot else {
          print("failed to get document")
          return
        }
        
        self.listing = try? dc.data(as: Listing.self)
        
        guard let listing = self.listing else {
          print("Failed to parse listing info.")
          return
        }
        
        guard let buyer = listing.buyer else {
          print("This listing has no buyer.")
          return
        }
        
        StorageViewModel.retrieveProfileImage(imagePath: buyer.profileImageURL) { image in
          self.buyerImage = image
        }
        
        StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) { image in
          self.sellerImage = image
        }
        
      }
  }
}
