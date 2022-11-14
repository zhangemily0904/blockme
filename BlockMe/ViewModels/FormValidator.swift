//
//  FormValidator.swift
//  BlockMe
//
//  Created by Brian Chou on 11/3/22.
//

import Foundation

class FormValidator {
  static func isValidPhoneNumber(number: String) -> Bool {
    let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
    return number.range(of: phonePattern, options: .regularExpression) != nil
  }

  static func isValidEmailAddr(email: String) -> Bool {
    let emailValidationRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
    let emailValidationPredicate = NSPredicate(format: "SELF MATCHES %@", emailValidationRegex)
    return emailValidationPredicate.evaluate(with: email)
  }
  
  static func isNewListingValid(expirationTime: Date, price: Float, availableLocations: [DiningLocation]) -> (Bool, String) {
    var isValid = true
    var errorMsg = ""
    
    if price < 0 {
      isValid = false
      errorMsg = "Price must be a positive number."
    }
    else if expirationTime <= Date.now {
      isValid = false
      errorMsg = "Expiration time must be in the future."
    }
    else if availableLocations.count < 1 {
      isValid = false
      errorMsg = "Must provide at least 1 available location."
    }
    
    return (isValid, errorMsg)
  }
  
  static func validateFields(email: String, number: String) -> Bool {
    return isValidEmailAddr(email: email) && isValidPhoneNumber(number: number)
  }
}


