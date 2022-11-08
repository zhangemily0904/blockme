//
//  VenmoFormatter.swift
//  BlockMe
//
//  Created by Wen Shan Jiang on 11/8/22.
//

import Foundation


class VenmoFormatter: Formatter {
  let pattern = "^[a-zA-Z0-9_-]*$"

  // venmo usernames should only contain letters, numbers, hyphen, and underscore. It must also be 5-30 characters long
  private func isValidVenmo(_ value: String) -> Bool {
    return (value.range(of: pattern, options: .regularExpression) != nil) && value.count > 4 && value.count < 31
  }

  override func string(for obj: Any?) -> String? {
      guard let string = obj as? String,
            isValidVenmo(string) else { return nil }

      return "@\(string)"
  }

  override func getObjectValue(
      _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
      for string: String,
      errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
  ) -> Bool {

      let venmoValue: String
      if string.contains("@") {
        venmoValue = String(string.dropFirst())
      } else {
        venmoValue = string
      }

      obj?.pointee = venmoValue as AnyObject
      return true
  }
}
