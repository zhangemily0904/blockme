//
//  OrderDetailsView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/9/22.
//

import SwiftUI

struct OrderDetailsView: View {
  @EnvironmentObject var appViewModel: AppViewModel
  @State var profileImage: UIImage? = nil
  var order: Listing
  var viewWidth: CGFloat
  var seller: Bool
  
  let dateFormatter = DateFormatter()
  
  func formatDate(date: Date) -> String {
    dateFormatter.dateFormat = "MMM d y, HH:mm"
    return dateFormatter.string(from: date)
  }
  
  var body: some View {
    HStack() {
      if let profileImage = profileImage {
        Image(uiImage: profileImage)
          .resizable()
          .frame(width: viewWidth / 6, height: viewWidth / 6, alignment: .leading) // dynamically scale size of profile image
          .clipShape(Circle())
      }
      VStack(alignment: .leading) {
        if seller {
          if let buyer = order.buyer {
            Text("Sold to \(buyer.firstName)").font(.medSmall)
          }
        } else {
          Text("Bought from \(order.seller.firstName)").font(.medSmall)
        }

        if let completedTime = order.completedTime {
          Text("\(formatDate(date: completedTime))").font(.regTiny).padding(.top, 1)
        }
        
        if let location = order.selectedLocation {
          Text(location.rawValue).font(.regTiny)
        }
      }.frame(width: 239 - viewWidth / 6, alignment: .leading) //overall frame is 332, frame width for price is 63, and frame width for image is viewWidth / 6
        .padding(.leading, 10)
      Text(String(format: "$%.2f", order.price)).font(.medMed).frame(width: 70, alignment: .trailing)
      
    }.padding(15)
    .background(Color("BlockMe Yellow"))
    .frame(width: viewWidth-40)
    .foregroundColor(.black)
    .onAppear {
      if seller {
        if let buyer = order.buyer {
          StorageViewModel.retrieveProfileImage(imagePath: buyer.profileImageURL) { image in
            profileImage = image
          }
        }
      }
      else {
        StorageViewModel.retrieveProfileImage(imagePath: order.seller.profileImageURL) { image in
          profileImage = image
        }
      }
    }
  }
}

