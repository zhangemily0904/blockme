//
//  StarRatingComponent.swift
//  BlockMe
//
//  Created by Brian Chou on 11/20/22.
//

import SwiftUI

struct StarRatingComponent: View {
  @Binding var rating: Int
  var maxRating = 5
  
  var offImage: Image?
  var onImage = Image(systemName: "star.fill")
  
  var offColor = Color.gray
  var onColor = Color("BlockMe Red")
  
    var body: some View {
      HStack{
          ForEach(1..<maxRating + 1, id:\.self){number in
              image(for: number)
                  .font(.system(size: 45))
                  .foregroundColor(number>rating ? offColor : onColor)
                  .onTapGesture {
                      rating = number
                      }
                  }
          }
    }
  
  func image(for number: Int) -> Image {
      if number > rating {
          return offImage ?? onImage
      } else {
          return onImage
      }
  }
}
