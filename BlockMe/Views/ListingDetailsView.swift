//
//  ListingDetailView.swift
//  BlockMe
//
//  Created by Brian Chou on 10/24/22.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseStorage
import WrappingHStack

struct ListingDetailsView: View {
  var listing: Listing
  var viewWidth: CGFloat
  @State var profileImage: UIImage? = nil
  
  var body: some View {
    VStack() {
      HStack() {
        if let profileImage = profileImage {
          Image(uiImage: profileImage)
            .resizable()
            .frame(width: viewWidth / 6, height: viewWidth / 6, alignment: .leading) // dynamically scale size of profile image
            .clipShape(Circle())
        }
        VStack(alignment: .leading) {
          Text(listing.seller.firstName).font(.medSmall)
          HStack {
            let timeRemaining = ListingDetailsView.dateComponentFormatter.string(from: MarketPlaceView().currentTime, to: listing.expirationTime)!
            let min = MarketPlaceView().calendar.dateComponents([.minute], from: MarketPlaceView().currentTime, to: listing.expirationTime).minute!
            switch min {
            case let x where x > 60:
              Circle.availableCircle
              Text("Expires in \(timeRemaining)").font(.regSmall).foregroundColor(Color("Expiration Green"))
            case let x where x > 30:
              Circle.limitCircle
              Text("Expires in \(timeRemaining)").font(.regSmall).foregroundColor(Color("Expiration Yellow"))
            default:
              Circle.unavailableCircle
              Text("Expires in \(timeRemaining)").font(.regSmall).foregroundColor(Color("Expiration Red"))
            }
          }
        }.frame(width: 239 - viewWidth / 6, alignment: .leading) //overall frame is 332, frame width for price is 63, and frame width for image is viewWidth / 6
          .padding(.leading, 10)
        Text(String(format: "$%.2f", listing.price)).font(.medMed).frame(width: 63, alignment: .trailing)
      }
      let i = listing.availableLocations.count - 1
      WrappingHStack(0...i, id:\.self) {
          switch listing.availableLocations[$0].rawValue {
          case "University Center":
            Capsule.UC
          case "Resnik":
            Capsule.Resnik
          case "Tepper":
            Capsule.Tepper
          case "La Prima (Wean)":
            Capsule.LaPrimaWean
          default:
            Capsule.LaPrimaGates
          }
        }
    }.padding(15)
      .background(Color("BlockMe Yellow"))
      .foregroundColor(.black)
      .frame(width: 332)
      .onAppear {
        StorageViewModel.retrieveProfileImage(imagePath: listing.seller.profileImageURL) { image in
          profileImage = image
        }
      }
  }
  
  private static let dateComponentFormatter: DateComponentsFormatter = {
          var formatter = DateComponentsFormatter()
          formatter.allowedUnits = [.day, .hour, .minute]
          formatter.unitsStyle = .brief
          return formatter
      }()
}

