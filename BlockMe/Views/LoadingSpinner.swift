//
//  LoadingSpinner.swift
//  BlockMe
//
//  Created by Brian Chou on 12/6/22.
//

import SwiftUI

struct LoadingSpinner: View {
  @State private var shouldAnimate = false
  
  var body: some View {
      HStack {
          Circle()
              .fill(Color("BlockMe Red"))
              .frame(width: 20, height: 20)
              .scaleEffect(shouldAnimate ? 1.0 : 0.5, anchor: .center)
              .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: shouldAnimate)
          Circle()
              .fill(Color("BlockMe Red"))
              .frame(width: 20, height: 20)
              .scaleEffect(shouldAnimate ? 1.0 : 0.5, anchor: .center)
              .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3), value: shouldAnimate)
          Circle()
              .fill(Color("BlockMe Red"))
              .frame(width: 20, height: 20)
              .scaleEffect(shouldAnimate ? 1.0 : 0.5, anchor: .center)
              .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6), value: shouldAnimate)
      }
      .onAppear {
          self.shouldAnimate = true
      }
  }
}
