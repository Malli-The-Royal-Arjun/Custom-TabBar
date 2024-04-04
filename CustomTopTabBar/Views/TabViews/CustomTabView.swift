//
//  TabView.swift
//  CustomTopTabBar
//
//  Created by Chennaboina Susheel Kumar Yadav TPR on 28/02/23.
//

import SwiftUI

struct CustomTabView: View{
    @Binding var isStoryTrip : Bool
    @State private var selectedTab: Int = 0
    @ObservedObject var taxInsight : TaxInsightViewModel
    let tabs: [Tab] = [.init(title: "My Tax Return"), .init(title: "Tasks"), .init(title: "Tax Insights")]
    init(isStoryTrip: Binding<Bool>, taxInsight: TaxInsightViewModel) {
        self._isStoryTrip = isStoryTrip
        self.taxInsight = taxInsight
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing: 0){
                TabItemView(tabs: tabs, geoWidth: UIScreen.main.bounds.width, selectedTab: $selectedTab)
                switch selectedTab{
                case 1:
                    TasksView(taxInsights: taxInsight, isExpanded: false)
                case 2:
                    TaxInsightsView(taxInsights: taxInsight)
                default:
                    MyTaxReturnView(taxInsights: taxInsight, isStoryTrip: $isStoryTrip, selectedTab: $selectedTab)
                }
                Spacer()
            }
        }.navigationBarTitleDisplayMode(.inline).navigationTitle("2022 United States Tax Return")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                    }){
                        HStack{
                            Image("left-arrow").rotationEffect(.degrees(180))
                            Text("Back")
                        }.font(.VialtoRegular16).foregroundColor(.primaryBlack)
                    }
                }
            }.edgesIgnoringSafeArea(.bottom)
    }
}

//struct CustomTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTabView(isStoryTrip: .constant(false), modelData: ViewSummaryModel(from: Decoder.self as! Decoder))
//    }
//}
