//
//  UserAvgRatingTests.swift
//  BlockMeTests
//
//  Created by Emily Zhang on 12/14/22.
//

import XCTest
@testable import BlockMe

final class UserAvgRatingTests: XCTestCase {

  let testUser1 = User(firstName: "Test", lastName: "User1", venmoHandle: "test-user-1", phoneNumber: "1234567890", profileImageURL: "", ratings: [])
  let testUser2 = User(firstName: "Test", lastName: "User2", venmoHandle: "test-user-2", phoneNumber: "1234567890", profileImageURL: "", ratings: [5])
  let testUser3 = User(firstName: "Test", lastName: "User3", venmoHandle: "test-user-3", phoneNumber: "1234567890", profileImageURL: "", ratings: [5, 4, 4, 3, 2])
  let testUser4 = User(firstName: "Test", lastName: "User4", venmoHandle: "test-user-4", phoneNumber: "1234567890", profileImageURL: "", ratings: [2, 1, 4, 3])
  let testUser5 = User(firstName: "Test", lastName: "User15", venmoHandle: "test-user-5", phoneNumber: "1234567890", profileImageURL: "", ratings: [3, 4, 5, 0, 4, 5])

  func testGetAvgRating() throws {
    let testCases = [
      testUser1.getAvgRating(): 0,
      testUser2.getAvgRating(): 5,
      testUser3.getAvgRating(): 3.6,
      testUser4.getAvgRating(): 2.5,
      testUser5.getAvgRating(): 3.5,
    ]
    
    for (rating, expected) in testCases {
      XCTAssertEqual(rating, Float(expected))
    }
  }
}
