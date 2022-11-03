//
//  FormValidator.swift
//  BlockMe
//
//  Created by Brian Chou on 11/3/22.
//

import Foundation

class FormValidator {
  static func validatePhoneNumber(number: String) -> Bool {
    let num = Int(number) ?? -1
    if num == -1 {
      print("Phone Number Error: not characters are numbers")
      return false
    }
    if number.count != 10 {
      print("Phone Number Error: invalid length, has to be 10 digits")
      return false
    }
    print("Phone number is good")
    return true
  }

  static func isValidEmailAddr(email: String) -> Bool {
    let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
    let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
    return emailValidationPredicate.evaluate(with: email)
  }
  
  static func validateFields(email: String, number: String) -> Bool {
    return isValidEmailAddr(email: email) && validatePhoneNumber(number: number)
  }
}
