//
//  FilterView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/14/22.
//

import SwiftUI
import MultiSlider

struct FilterListingView: View {
  typealias LocationSelection = (DiningLocation, Bool)
  @ObservedObject var listingRepository: ListingRepository
  @Binding var show: Bool
  @State var priceRange: [CGFloat]
  @State var expirationTimeMin: Date
  @State var expirationTimeMax: Date
  @State var locations: [LocationSelection]
  @State var rating: Double
  @State private var isEditing = false

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
          Text("Filter").font(.medMed).frame(width: 352)
          
          VStack() {
            Text("Expiration Time").font(.medSmall).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 15)
            HStack() {
              DatePicker("", selection: $expirationTimeMin, displayedComponents: .hourAndMinute)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.medSmall)
                .frame(width: 100, alignment: .leading)
              
              Text("to").frame(width: 96, alignment: .center)
              
              DatePicker("", selection: $expirationTimeMax, displayedComponents: .hourAndMinute)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.medSmall)
                .frame(width: 100, alignment: .trailing)
            }.frame(maxWidth: .infinity)
          }.frame(width: 352)
         
          VStack() {
            Text("Price").font(.medSmall).frame(maxWidth: .infinity, alignment: .leading)

            MultiValueSlider(
                value: $priceRange,
                maximumValue: CGFloat(listingRepository.findMaxPrice()),
                snapStepSize: 1,
                valueLabelPosition: .top,
                orientation: .horizontal,
                outerTrackColor: .lightGray,
                keepsDistanceBetweenThumbs: false
            )
                .frame(width: 352)
                .scaledToFit()
            
          }.frame(width: 352)
            .padding(.bottom, 10)
          
          VStack {
            HStack {
              Text("Location").font(.medSmall).frame(maxWidth: 100, alignment: .leading).offset(y: -68).offset(x: -45)
              VStack (alignment: .leading, spacing: 10) {
                ForEach(0..<locations.count) { i in
                  HStack {
                    Button(action: {
                      locations[i].1 = locations[i].1 ? false : true
                    }) {
                      HStack{
                        if locations[i].1 {
                          Image(systemName: "checkmark.circle.fill")
                            .foregroundColor( Color("BlockMe Red"))
                        } else {
                          Image(systemName: "checkmark.circle")
                            .foregroundColor(Color("BlockMe Red"))
                        }
                        Text(locations[i].0.rawValue).font(.regMed)
                          .foregroundColor(.black)
                      }
                    }
                  }
                }
              }
            }.padding(.bottom, 10)
          }.frame(width: 352)
          
          VStack {
            Text("Rating (at least)").font(.medSmall).frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 10)
            
            VStack {
              VStack(alignment: .leading, spacing: 7){
                HStack {
                  ForEach(0..<6) { i in
                  
                    Button(action: {
                      rating = Double(i)
                    }) {
                      HStack{
                        Text("\(i)")
                        Image(systemName: "star.fill")
                          .resizable()
                          .frame(width:15,height:15)
                      }
                      .frame(width: 52, height: 30)
                     
                    }
                    .background(rating == Double(i) ? Color("BlockMe Red") : Color(UIColor.lightGray))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    
                  }.offset(x:-40)
                }
              }
            }.frame(width: 270, alignment: .leading)
            
          }.frame(width: 352)
            .padding(.bottom, 10)
          
          Button(action:{
            listingRepository.priceRange = [priceRange[0], priceRange[1]]
            listingRepository.expirationTimeMin = expirationTimeMin
            listingRepository.expirationTimeMax = expirationTimeMax
            listingRepository.locations = locations.filter{$0.1}.map{$0.0}
            listingRepository.rating = rating
            listingRepository.getFiltered()
            dismiss()
          }) {
            Text("Apply")
          }.buttonStyle(RedButton())
            .font(.medSmall)
            .padding(.top, 10)
          
          Button(action:{
            expirationTimeMin = Date.now
            expirationTimeMax = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date.now
            priceRange = [0.0, CGFloat(listingRepository.findMaxPrice())]
            locations = DiningLocation.allCases.map{($0, true)}
            rating = 0.0
          }) {
            Text("Reset")
          }.buttonStyle(WhiteButton())
            .font(.medSmall)
        }
        
      }
      
    }
}


