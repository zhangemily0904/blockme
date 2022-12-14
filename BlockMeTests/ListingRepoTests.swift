//
//  ListingRepoTests.swift
//  BlockMeTests
//
//  Created by Emily Zhang on 12/7/22.
//

import XCTest

@testable import BlockMe

final class ListingRepoTests: XCTestCase {
  // Start with a basic setup method
  let expired: TimeInterval = 5
  var expectation: XCTestExpectation!
  let listingRepository = ListingRepository()
  let listingSeller = ListingUser(id: "Z6FeYlawiCZembWLQ5HeE4F5qO12", firstName: "Unit", lastName: "Tester", venmoHandle: "@unit-tester", phoneNumber: "(234) 567-8901", profileImageURL: "images/Z6FeYlawiCZembWLQ5HeE4F5qO12.jpeg", rating: 5.0)
 
  override func setUpWithError() throws {
    expectation = expectation(description: "Server responds in reasonable time")
  }

  override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

//  func testExample() throws {
//    let result = XCTWaiter.wait(for:[self.expectation], timeout:1.0)
//    if result == XCTWaiter.Result.timedOut {
//      XCTAssertTrue(listingRepository.listings.count > 0)
//      self.expectation.fulfill()
//    } else {
//      XCTFail("Delay interrupted")
//    }
//  }
  
  func testAddDeleteListing() throws {
    let newListing = Listing(seller: listingSeller, price: 10.0, expirationTime: Date.now + 30, availableLocations: [DiningLocation.LaPrimaWean])
    listingRepository.add(listing: newListing)
//    sleep(10)
    let listings = listingRepository.listings.filter{$0.seller.id == listingSeller.id}
    XCTAssertEqual(listings.count, 1)
//    for listing in listings {
//      listingRepository.delete(listing: listing) { errorMsg in
//        XCTAssertNil(errorMsg)
//      }
//    }
    self.expectation.fulfill()
    
    
//
//    let result = XCTWaiter.wait(for:[self.expectation], timeout:2.0)
//    if result == XCTWaiter.Result.timedOut {
//
//
//    } else {
//      XCTFail("Delay interrupted")
//    }
//
  }
}
