//
//  SortListingView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/15/22.
//

import SwiftUI

struct SortListingView: View {
  @ObservedObject var listingRepository: ListingRepository
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    ZStack {
      VStack() {
        Button(action: {dismiss()}){
          Image("cancel")
            .resizable()
            .frame(width: 30, height: 30)
        }
        .frame(width: 296, alignment: .trailing)
        
        Text("Sort").font(.medMed).frame(width: 296)
        
        Button(action: {
          listingRepository.sortBy = .priceAsc
          listingRepository.getSorted()
          dismiss()
        }){
          Text("Price asc")
            .foregroundColor(Color.black)
        }
        
        Button(action: {
          listingRepository.sortBy = .priceDesc
          listingRepository.getSorted()
          dismiss()
        }){
          Text("Price desc")
            .foregroundColor(Color.black)
        }
        
        Button(action: {
          listingRepository.sortBy = .timeAsc
          listingRepository.getSorted()
          dismiss()
        }){
          Text("Expiration time asc")
            .foregroundColor(Color.black)
        }
        
        Button(action: {
          listingRepository.sortBy = .timeDesc
          listingRepository.getSorted()
          dismiss()
        }){
          Text("Expiration time desc")
            .foregroundColor(Color.black)
        }
        
        Button(action: {
        }){
          Text("Rating")
            .foregroundColor(Color.black)
        }
        
        
      }
    }
  }
}

