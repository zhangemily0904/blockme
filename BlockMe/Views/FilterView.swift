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
  @Binding var show: Bool
  @State var expirationTime1: Date = Date.now
  @State var expirationTime2: Date = (Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date()) ?? Date.now)
  @State var priceRange: [CGFloat] = [0.0, 15.0]
  @State var locations: [LocationSelection] = DiningLocation.allCases.map{($0, false)}
  @Environment(\.dismiss) var dismiss
  
  func getEOD() -> Date {
    var components = DateComponents()
    components.hour = 23
    components.minute = 59
    return Calendar.current.date(from: components) ?? Date.now
  }
  

  
    var body: some View {
      ZStack {
        
        VStack() {
          Button(action: {dismiss()}){
            Text("x") // TODO: replace with icon
          }
          Text("Filter").font(.medMed).frame(width: 296).padding(.top, 30)
          
          VStack() {
            Text("Expiration Time").font(.medSmall).frame(maxWidth: .infinity, alignment: .leading).padding(.top, 15)
            HStack() {
              DatePicker("", selection: $expirationTime1, displayedComponents: .hourAndMinute)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.medSmall)
                .frame(width: 100, alignment: .leading)
              
              Text("to").frame(width: 96, alignment: .center)
              
              DatePicker("", selection: $expirationTime2, displayedComponents: .hourAndMinute)
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
                maximumValue: 15,
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
          }
          Button(action:{}) {
            Text("Apply")
          }.buttonStyle(SmallRedButton())
            .font(.medSmall)
          
          Button(action:{}) {
            Text("Reset")
          }.buttonStyle(SmallWhiteButton())
            .font(.medSmall)
        }
        
      }
      
    }
}


