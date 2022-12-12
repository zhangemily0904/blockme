//
//  FormValidatorTests.swift
//  BlockMeTests
//
//  Created by Brian Chou on 12/11/22.
//

import XCTest
@testable import BlockMe

final class FormValidatorTests: XCTestCase {

  func testIsValidPhoneNumber() throws {
      let testCases = [
        "(123)4567890": true,
        "123 456 7890": true,
        "(123)456-7890": true,
        "(123)-456-7890": true,
        "not a number": false,
        "123 123 123": false,
        "(123) 123 - 5678": false,
        "": false
      ]
    
    for (number, expected) in testCases {
      XCTAssertEqual(FormValidator.isValidPhoneNumber(number: number), expected)
    }
  }
  
  func testIsValidEmailAddress() throws {
    let testCases = [
      "": false,
      "123": false,
      "test": false,
      "test@gmail.com": true,
      "123@gmail.com": true,
      "test123@yahoo.com": true,
      "bc@andrew.cmu.edu": true
    ]
    
    for (email, expected) in testCases {
      XCTAssertEqual(FormValidator.isValidEmailAddr(email: email), expected)
    }
  }
  
  func testIsNewListingValid() throws {
    var (res, _) = FormValidator.isNewListingValid(expirationTime: Date.now + 10, price: 2.00, availableLocations: [])
    XCTAssertFalse(res)
    
    (res, _) = FormValidator.isNewListingValid(expirationTime: Date.now - 10, price: 2.00, availableLocations: [(DiningLocation.LaPrimaWean)])
    XCTAssertFalse(res)
    
    (res, _) = FormValidator.isNewListingValid(expirationTime: Date.now + 10, price: -3.00, availableLocations: [(DiningLocation.LaPrimaWean)])
    XCTAssertFalse(res)
    
    (res, _) = FormValidator.isNewListingValid(expirationTime: Date.now + 10, price: 0, availableLocations: [(DiningLocation.LaPrimaWean)])
    XCTAssertTrue(res)
    
    (res, _) = FormValidator.isNewListingValid(expirationTime: Date.now + 10, price: 2.00, availableLocations: [(DiningLocation.LaPrimaWean)])
    XCTAssertTrue(res)
  }
}
