//
//  TaxInsightsView.swift
//  CustomTopTabBar
//
//  Created by Chennaboina Susheel Kumar Yadav TPR on 28/02/23.
//

import SwiftUI

struct TaxReturnResultsModel: Codable {
    var header : String
    var chips : [String]
    var value: [Int]
}

struct TaxInsightsView: View {
    @ObservedObject var taxInsights : TaxInsightViewModel
    @State var isShow : Bool = false
    var body: some View {
        ZStack{
            Color.gray1.ignoresSafeArea()
            ScrollView (.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24){
                    
                    MyTaxResultsCard(taxInsights: taxInsights, isShow: $isShow)
            
//                    MyTaxHighlitesCard(taxHighlight: (taxInsights.viewSummaryData[0].taxReturnInfo?.taxHighlights)!)
                    Spacer()
                    
                }.padding([.horizontal, .top])
            }
        }
    }
}

//struct TaxInsightsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaxInsightsView(taxInsights: TaxInsightViewModel())
//    }
//}

struct MyTaxResultsCard: View{
    @ObservedObject var taxInsights : TaxInsightViewModel
    @Binding var isShow : Bool
    var body: some View{
        VStack(spacing: 0){
            VStack(alignment: .leading, spacing: 10){
                Image("mytaxreturnresultsIcon")
                Text("My Tax Return Results")
                    .font(.VialtoBold24)
            }.padding(16).foregroundColor(.primaryBlack)
                .frame(width: UIScreen.main.bounds.width-32, height: 109, alignment: .leading)
                .background(Color.statusBlue2.opacity(0.4))
            
            Spacer()
            VStack(alignment: .leading, spacing: 8){
                ForEach(0..<taxInsights.taxResultsView.count, id: \.self){ id in
                    Text(taxInsights.taxResultsView[id].header)
                        .font(.VialtoMedium14)
                    ForEach(0..<taxInsights.taxResultsView[id].chips.count, id: \.self){ value in
                        LeftRightLabel(label: taxInsights.taxResultsView[id].chips[value], value: "\(abs(taxInsights.taxResultsView[id].value[value])) \(TaxInsightViewModel.currencyType)", font: .VialtoRegular14)
                    }
                    LeftRightLabel(label: "Total", value: "\(abs(taxInsights.taxResultsView[id].value.reduce(0, +))) \(TaxInsightViewModel.currencyType)", font: .VialtoBold14)
                    LineCard()
                }
                
        
                VStack(alignment: .leading, spacing: 8){
                    Text("TAX RECONCILIATION")
                        .font(.VialtoMedium14)
                    LeftRightLabel(label: "Due to employer", value: "\(taxInsights.refundToMe.count != 0 ? abs(taxInsights.refundToMe[0].value.reduce(0, +)) : 0) \(TaxInsightViewModel.currencyType)", font: .VialtoBold14)
                    LineCard()
                }
                
            
                LeftRightLabel(label: "Net amount in pocket", value: "\(taxInsights.paymentDue.count != 0 ? abs(taxInsights.paymentDue[0].value.reduce(0, +)) : 0) \(TaxInsightViewModel.currencyType)", font: .VialtoBold16)
                
                Text("This is the net amount due to or from you as a result of all your tax filings and tax reconciliation calculation (if applicable)")
                    .italic().font(.VialtoRegular12)
                    .foregroundColor(.gray7)
                LineCard()
                HStack{
                    Text(!isShow ? "Show more" : "Show less").font(.VialtoRegular14)
                    Image("left-arrow").renderingMode(.template).rotationEffect(.degrees(isShow ? 270 : 90))
                }.foregroundColor(.secondaryMedTeal)
                    .frame(width: UIScreen.main.bounds.width-32, alignment: .center)
                    .onTapGesture {
                        self.isShow.toggle()
                    }
                
                if isShow{
                    Text("OTHER TAX RETURN RESULTS WITH NO IMPACT TO YOU")
                        .fontWeight(.medium).padding(.top, 8)
                    BulletList(listItems: ["5,643.23 USD California refund will be applied to your next year tax due", "1,450 USD Federal refund will be paid directly to your employer", "450 USD District of Columbia balance due will be paid by your employer"], listItemSpacing: 10)
                }
                
            }.padding(16).frame(width: UIScreen.main.bounds.width-32, alignment: .leading).font(.VialtoRegular14)
        }.padding(.bottom, 24).background(Color.primaryWhite).cornerRadius(10)
    }
}

struct MyTaxHighlitesCard : View{
//    @State var taxHighlight : TaxReturnInfoTaxHighlights
    @State var showingAlert = false
    @State var incomeType = ["Employment Income", "Personal Income", "Effective tax rate"]
    @State var alertMessages = ["includes any wages, salaries, or other income earned through employment during the tax year." , "includes any interest, dividends, or other sources of income not included in your employment income.", "is the average rate at which your income is taxed, excluding social tax. "]
    @State var index = 0
    var body: some View{
        VStack(spacing: 0){
            VStack(alignment: .leading, spacing: 10){
                Image("mytaxhighlitesIcon")
                Text("My tax Highlights")
                    .font(.VialtoBold24)
            }.padding(16).foregroundColor(.primaryBlack)
                .frame(width: UIScreen.main.bounds.width-32, height: 109, alignment: .leading)
                .background(Color.secondaryLightTeal.opacity(0.4))
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8){
                Text("Review the highlights below to see key factors affecting your tax return results.")
                    .padding(.bottom, 8)
                Text("TOTAL INCOME")
                    .fontWeight(.medium)
//
//                LeftRightLabel(label: "Employment income", value: "\(taxHighlight.employmentIncome) \(TaxInsightViewModel.currencyType)", font: .VialtoRegular14)
//
//                LeftRightLabel(label: "Personal income", value: "\(taxHighlight.personalIncome) \(TaxInsightViewModel.currencyType)", font: .VialtoRegular14)
//
//                LineCard()
//
//                LeftRightLabel(label: "Effective Tax Rate", value: "\(taxHighlight.effectiveTaxRate*100) %", font: .VialtoRegular14)
                
                LineCard()
                
                VStack(alignment: .leading, spacing: 8){
                    Text("WHAT IS IMPACTING MY RESULTS?")
                        .fontWeight(.medium)
//                    Text(taxHighlight.taxBalanceReason)
                    
                    Text("FAQs") .fontWeight(.medium) .padding(.top, 8)
                
                    ForEach(0..<incomeType.count, id: \.self){index in
                        HowIncomeCalcualtedCard(isCollaps: false, label: "How is \(incomeType[index].lowercased()) calculated?")
//                            .onTapGesture {
//                                self.index = index
//                                self.showingAlert = true
//                            }
                    }
                }
            }.padding(16).frame(width: UIScreen.main.bounds.width-32, alignment: .leading).font(.VialtoRegular14)
            
        }.padding(.bottom, 24).background(Color.primaryWhite).cornerRadius(10)
        
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(incomeType[index]), message: Text(alertMessages[index]), dismissButton: .default(Text("Close")))
            }
    }
}

struct MyTaxHighlitesCard_Previews: PreviewProvider {
    static var previews: some View {
        MyTaxHighlitesCard()
    }
}

struct LeftRightLabel: View{
    @State var label: String
    @State var value : String
    @State var font: Font
    var body: some View{
        HStack{
            Text(label)
            Spacer()
            Text(value)
        }.font(font)
    }
}

struct HowIncomeCalcualtedCard: View{
    @State var isCollaps : Bool
    @State var label: String
    var body: some View{
        VStack{
            HStack{
                Text(label)
                Spacer()
                Image(systemName: isCollaps ? "minus" : "plus")
            }.padding(8).background(Color.gray2)
                .onTapGesture {
                    self.isCollaps.toggle()
                }
            if isCollaps{
                Text("**Employment Income** includes any wages, salaries, or other income earned through employment during the tax year.").lineSpacing(3)
                    .padding(.vertical, 4)
            }
        }.frame(maxWidth: .infinity)
    }
}

struct LineCard : View{
    var body: some View{
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.gray5)
            .padding(.bottom, 10)
    }
}

struct BulletList: View {
    var listItems: [String]
    var listItemSpacing: CGFloat? = nil
    var bullet: String = "•"
    var bulletWidth: CGFloat? = nil
    var bulletAlignment: Alignment = .leading
    
    var body: some View {
        VStack(alignment: .leading, spacing: listItemSpacing) {
            ForEach(listItems, id: \.self) { data in
                HStack(alignment: .top){
                    Text(bullet)
                        .font(.VialtoBold16)
                        .frame(width: bulletWidth,
                               alignment: bulletAlignment)
                    Text(data).font(.VialtoRegular14)
                        .lineSpacing(3)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                }
            }
        }
    }
}
