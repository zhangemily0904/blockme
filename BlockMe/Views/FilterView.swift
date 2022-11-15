//
//  FilterView.swift
//  BlockMe
//
//  Created by Emily Zhang on 11/14/22.
//

import SwiftUI

struct FilterView: View {
  typealias LocationSelection = (DiningLocation, Bool)
  @Binding var show: Bool
  @State var expirationTime1: Date = Date.now
  @State var expirationTime2: Date = Date.now
  @State var price: Float = 0.0
  @State var locations: [LocationSelection] = DiningLocation.allCases.map{($0, false)}

    var body: some View {
      ZStack {
        
        VStack() {
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
            Slider(value: $price, in: 0...15,  step: 0.5){
            } minimumValueLabel: {
              Text("0")
            } maximumValueLabel: {
              Text("15")
            }
            Text("\(String(format: "%.1f", price))")
            
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


