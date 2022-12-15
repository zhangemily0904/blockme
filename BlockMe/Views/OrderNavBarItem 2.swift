//
//  OrderNavBarItem.swift
//  BlockMe
//
//  Created by Emily Zhang on 12/6/22.
//

import SwiftUI
import PagerTabStripView


private class NavTabViewTheme: ObservableObject {
    @Published var textColor = Color.gray
    @Published var backgroundColor = Color.white
}

struct OrderNavBarItem: View, PagerTabViewDelegate {
    let title: String
    @ObservedObject fileprivate var theme = NavTabViewTheme()

    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(theme.textColor)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BlockMe Background"))
    }

    func setState(state: PagerTabViewState) {
        switch state {
        case .selected:
          self.theme.textColor = Color("BlockMe Red")
        default:
          self.theme.textColor = .gray
        }
    }
}
