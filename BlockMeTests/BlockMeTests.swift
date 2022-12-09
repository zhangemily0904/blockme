//
//  BlockMeTests.swift
//  BlockMeTests
//
//  Created by Emily Zhang on 12/7/22.
//

import XCTest

@testable import BlockMe

final class BlockMeTests: XCTestCase {
  // Start with a basic setup method
  let expired: TimeInterval = 5
  var expectation: XCTestExpectation!
  let listingRepository = ListingRepository()
  
  override func setUpWithError() throws {
    expectation = expectation(description: "Server responds in reasonable time")
  }

  override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() throws {
    XCTAssertTrue(listingRepository.listings.count >= 0)
    self.expectation.fulfill()

    waitForExpectations(timeout: expired)
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    measure {
        // Put the code you want to measure the time of here.
    }
  }

}
