//
//  TabItemView.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 08/03/23.
//

import SwiftUI

struct Tab {
    var title: String
}

struct TabItemView: View {
    var fixed = true
    var tabs: [Tab]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< tabs.count, id: \.self) { row in
                VStack {
                    Spacer()
                    Text(tabs[row].title)
                        .font(Font.system(size: 14, weight: selectedTab == row ? .bold : .semibold))
                        .foregroundColor(selectedTab == row ? .primaryTeal : .gray3)
                        Spacer()
                    //  Bar indicator
                    Rectangle().fill(selectedTab == row ? Color.primaryTeal : Color.clear)
                        .frame(height: 4)
                }.padding(.horizontal, 13)
                    .frame(width: fixed ? (geoWidth / CGFloat(tabs.count)) : .leastNormalMagnitude, height: 40)
                    .fixedSize().background(Color.secondaryDarkTeal)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = row
                        }
                    }
            }
        }
    }
}

struct TabItemView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemView(tabs: [.init(title: "My Tax Return"), .init(title: "Tasks"), .init(title: "TaxInsights")], geoWidth: UIScreen.main.bounds.width, selectedTab: .constant(0))
    }
}

