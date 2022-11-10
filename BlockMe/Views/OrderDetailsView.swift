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
          .frame(width: viewWidth / 5, height: viewWidth / 5) // dynamically scale size of profile image
          .clipShape(Circle())
      }
      VStack(alignment: .leading) {
        if seller {
          if let buyer = order.buyer {
            Text("Sold to \(buyer.firstName)").bold()
          }
        } else {
          Text("Bought from \(order.seller.firstName)").bold()
        }
        Text(String(format: "$%.2f", order.price))
        // TODO: show time left instead
        if let completedTime = order.completedTime {
          Text("\(formatDate(date: completedTime))")
        }
        if let location = order.selectedLocation {
          Text(location.rawValue)
        }
        
      }
    }
    .background(Color("BlockMe Yellow"))
    .frame(width: 332, height: 121)
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

