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
        VStack(alignment: .leading) {
          ForEach(0..<SortBy.allCases.count) { i in
            HStack {
              Button(action: {
                listingRepository.sortBy = SortBy.allCases[i]
                listingRepository.getSorted()
                dismiss()
              }) {
                HStack{
                  if listingRepository.sortBy ==  SortBy.allCases[i] {
                    Image(systemName: "checkmark")
                      .foregroundColor(.green)
                  } 
              
                  Text(SortBy.allCases[i].rawValue).font(.regMed)
                    .foregroundColor(.black)
                    .frame(alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }
              .offset(x:25)
            }
            Divider()
          }
        }
        .padding(.top, 15)
      }
    }
  }
}

