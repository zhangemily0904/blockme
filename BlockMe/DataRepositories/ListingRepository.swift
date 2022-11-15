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
  @Published var filteredListings: [Listing] = []
  @Published var currentListings: [Listing] = []
  private var cancellables: Set<AnyCancellable> = []
  
  @Published var priceRange: [CGFloat] = [0.0, -1.0]
  @Published var expirationTimeMin: Date = Date.now
  @Published var expirationTimeMax: Date = (Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date.now)
  @Published var locations = DiningLocation.allCases
  
  init() {
    self.get()
    print(self.listings)
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
        
        print("listings \(self.listings)")
        self.currentListings = self.listings.filter {
          $0.buyer == nil && $0.expirationTime > Date.now
        }
        
        self.filteredListings = self.currentListings
      }
  }
  
  func getFiltered() {
    self.filteredListings = self.currentListings.filter{
      $0.expirationTime >= self.expirationTimeMin && $0.expirationTime <= self.expirationTimeMax &&
      $0.price >= Float(self.priceRange[0]) && $0.price <= Float(self.priceRange[1]) &&
      !$0.availableLocations.allSatisfy {!self.locations.contains($0)}
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
  
  func findMaxPrice() -> CGFloat {
    return CGFloat(self.currentListings.map{$0.price}.max() ?? 0)
  }
}
