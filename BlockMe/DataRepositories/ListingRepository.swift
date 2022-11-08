//
//  ListingRepository.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class ListingRepository: ObservableObject {
  private let path: String = "listings"
  private let store = Firestore.firestore()
  
  @Published var listings: [Listing] = []
  @Published var currentListings: [Listing] = []
  private var cancellables: Set<AnyCancellable> = []
  
  init() {
    self.get()
  }
  
  func get() {
    store.collection(path)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          print("Error getting listing: \(error.localizedDescription)")
          return
        }

        self.listings = querySnapshot?.documents.compactMap { document in
          try? document.data(as: Listing.self)
        } ?? []
        
        self.currentListings = self.listings.filter {
          $0.buyer == nil && $0.expirationTime > Date.now
        }
      }
  }
  
  func add(listing: Listing) {
    do {
      let newListing = listing
      _ = try store.collection(path).addDocument(from: newListing)
    } catch {
      fatalError("Unable to add book: \(error.localizedDescription).")

    }
  }
  
  func update(listing: Listing) -> Bool {
    do {
      guard let id = listing.id else{
        print("error retrieving listing id")
        return false
      }
      try store.collection(path).document(id).setData(from: listing)
      return true
    } catch {
      print("Unable to update listing: \(error.localizedDescription).")
      return false
    }
  }
  
  // returns an active listing by the logged in user if it exists
  func getCurrentListingForSeller(uid: String) -> Listing? {
    let l = self.listings.filter {
      $0.seller.id == uid && $0.expirationTime > Date.now && $0.buyer == nil
    }
    return l.first
  }
  
  // returns a listing that the logged in user is in the process of selling
  func getPendingListingForSeller(uid: String) -> Listing? {
    let l = self.listings.filter {
      $0.seller.id == uid && $0.buyer != nil && $0.completedTime == nil
    }
    return l.first
  }
  
  // returns a listing that the logged in user is in the process of purchasing
  // assuming that cancelled transactions will set buyer to null (rollback)
  func getPendingListingForBuyer(uid: String) -> Listing? {
    let l = self.listings.filter {
      $0.buyer?.id == uid && $0.completedTime == nil
    }
    return l.first
  }
  
  func cancelTransactionForListing(listing: Listing) -> Bool {
    var listing = listing
    listing.buyer = nil
    listing.buyerStatus = nil
    listing.sellerStatus = nil
    listing.completedTime = nil
    return self.update(listing: listing)
  }
}
