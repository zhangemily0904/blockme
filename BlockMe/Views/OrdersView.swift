//
//  OrdersView.swift
//  BlockMe
//
//  Created by Brian Chou on 11/2/22.
//

import SwiftUI
import PagerTabStripView

struct OrdersView: View {
   @State var selection = 0
  
    var body: some View {
      ZStack {
        Color("BlockMe Background").ignoresSafeArea()
        PagerTabStripView(selection: $selection) {
              PurchasedOrdersView()
                .pagerTabItem {
                  OrderNavBarItem(title:"Purchased")
                }
              SoldOrdersView()
                .pagerTabItem {
                  OrderNavBarItem(title:"Sold")
                }
        }
        .pagerTabStripViewStyle(.barButton(indicatorBarColor: .blue, tabItemSpacing: 0, tabItemHeight: 50))
          
      }
    }
}

