//
//  VenmoFormatterTests.swift
//  BlockMeTests
//
//  Created by Emily Zhang on 12/14/22.
//

import XCTest
@testable import BlockMe

final class VenmoFormatterTests: XCTestCase {
  let venmoFormatter = VenmoFormatter()
  
  func testIsValidVenmo() throws {
      let testCases = [
        "test-venmo": true,
        "test_venmo": true,
        "testvenmo123": true,
        "test venmo": false,
        "testvenmotestvenmotestvenmotestvenmo": false,
        "test-venmo!": false,
        "<>?!+=": false
      ]
    
    for (venmo, expected) in testCases {
      XCTAssertEqual(venmoFormatter.isValidVenmo(venmo), expected)
    }
  }
  
  func testFormatter() throws {
    let testCases = [
      "test-venmo": "@test-venmo",
      "test_venmo": "@test_venmo",
      "testvenmo123": "@testvenmo123",
      "test venmo": nil,
      "testvenmotestvenmotestvenmotestvenmo": nil,
      "test-venmo!": nil,
      "<>?!+=": nil
    ]
    for (venmo, expected) in testCases {
      XCTAssertEqual(venmoFormatter.string(for: venmo), expected)
    }
  }
}
