//
//  LoadingSpinner.swift
//  BlockMe
//
//  Created by Brian Chou on 12/6/22.
//

import SwiftUI

struct LoadingSpinner: View {
  var body: some View {
//    ZStack {
//      SpinnerCircle()
//    }.frame(width: 200, height: 200)
    Text("temp")
  }
}

struct SpinnerCircle: View {
  var start: CGFloat
  var end: CGFloat
  var rotation: Angle
  var color: Color
  
  var body: some View {
    Circle()
      .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
      .trim(from: start, to: end)
      .fill(color)
      .rotationEffect(rotation)
  }
}
