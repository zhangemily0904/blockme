//
//  TransactionView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/7/22.
//

import SwiftUI

struct TransactionView: View {
  @ObservedObject var listingViewModel: ListingViewModel
  var isSeller: Bool
  
  init(listingId: String, isSeller: Bool) {
    listingViewModel = ListingViewModel(id: listingId)
    self.isSeller = isSeller
  }
  
    var body: some View {
      VStack {
        
      }
    }
}
