//
//  FilterView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/14/22.
//

import SwiftUI
import MultiSlider

struct FilterView: View {
  typealias LocationSelection = (DiningLocation, Bool)
  @ObservedObject var listingRepository: ListingRepository
  @Binding var show: Bool
  @State var priceRange: [CGFloat]
  @State var expirationTimeMin: Date = Date.now
  @State var expirationTimeMax: Date = (Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date.now)
  @State var locations: [LocationSelection] = DiningLocation.allCases.map{($0, true)}
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
          Text("Filter").font(.medMed).frame(width: 296)
          
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
          }.frame(width: 296)
         
          VStack() {
            Text("Price").font(.medSmall).frame(maxWidth: .infinity, alignment: .leading)

            MultiValueSlider(
                value: $priceRange,
                maximumValue: priceRange[1],
                snapStepSize: 1,
                valueLabelPosition: .top,
                orientation: .horizontal,
                outerTrackColor: .lightGray,
                keepsDistanceBetweenThumbs: false
            )
                .frame(width: 320)
                .scaledToFit()
            
          }.frame(width: 296)
            .padding(.bottom, 15)
                      
          HStack {
            Text("Location").font(.medSmall).frame(width: 100, alignment: .leading).offset(y: -68)
            VStack (alignment: .leading, spacing: 10) {
              ForEach(0..<locations.count) { i in
                HStack {
                  Button(action: {
                    locations[i].1 = locations[i].1 ? false : true
                  }) {
                    HStack{
                      if locations[i].1 {
                        Image(systemName: "checkmark.circle.fill")
                          .foregroundColor(.green)
                      } else {
                        Image(systemName: "checkmark.circle")
                          .foregroundColor(.green)
                      }
                      Text(locations[i].0.rawValue).font(.regMed)
                        .foregroundColor(.black)
                    }
                  }
                }
              }
            }
          }.padding(.bottom, 15)
          Button(action:{
            listingRepository.priceRange = [Float(priceRange[0]), Float(priceRange[1])]
            listingRepository.expirationTimeMin = expirationTimeMin
            listingRepository.expirationTimeMax = expirationTimeMax
            listingRepository.locations = locations.filter{$0.1}.map{$0.0}
            listingRepository.getFiltered()
            dismiss()
          }) {
            Text("Apply")
          }.buttonStyle(SmallRedButton())
            .font(.medSmall)
          
          Button(action:{
            expirationTimeMin = Date.now
            expirationTimeMax = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date.now
            priceRange = [0.0, CGFloat(listingRepository.findMaxPrice())]
            locations = DiningLocation.allCases.map{($0, true)}
          }) {
            Text("Reset")
          }.buttonStyle(SmallWhiteButton())
            .font(.medSmall)
        }
        
      }
      
    }
}


