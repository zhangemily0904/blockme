//
//  OrdersView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/2/22.
//

import SwiftUI

struct OrdersView: View {
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        Text("Orders").font(.title)
      }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}
