//
//  MainContentView.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 10/03/23.
//

import SwiftUI

struct MainContentView: View {
    @State var isStoryTrip : Bool = false
    @ObservedObject var taxInsight = TaxInsightViewModel()
    var body: some View {
        NavigationView {
            ZStack{
                if self.isStoryTrip {
                    TaxStoryView(storyTimer: StoryTimer(items: 6, interval: 3.0, isStoryTrip: $isStoryTrip)).navigationBarHidden(true)
                } else {
                    if taxInsight.viewSummaryData.count != 0{
                        CustomTabView(isStoryTrip: $isStoryTrip, taxInsight: taxInsight)
                    }
                }
            }.onAppear{
                self.taxInsight.dataAdded()
            }
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}

