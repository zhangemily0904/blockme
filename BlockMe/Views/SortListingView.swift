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
        .frame(width: 352, alignment: .trailing)
        
        Text("Sort").font(.medMed).frame(width: 352)
        VStack(alignment: .leading) {
          ForEach(0..<SortBy.allCases.count) { i in
            HStack {
              Button(action: {
                listingRepository.sortBy = SortBy.allCases[i]
                listingRepository.getSorted()
                dismiss()
              }) {
                HStack{
                  Text(SortBy.allCases[i].rawValue).font(.regMed)
                    .foregroundColor(.black)
                    .frame(maxWidth: 300, alignment: .leading)
                  if listingRepository.sortBy ==  SortBy.allCases[i] {
                    Image(systemName: "checkmark")
                      .foregroundColor(.green)
                      .frame(maxWidth: 52, alignment: .trailing)
                  }
                }
              }
            }
            Divider()
          }
        }
        .frame(width: 352)
        .padding(.top, 15)
      }
    }
  }
}

