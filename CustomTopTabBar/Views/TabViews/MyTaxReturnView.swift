//
//  MyTaxReturnView.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 06/03/23.
//

import SwiftUI

struct MyTaxReturnView: View {
    @State var taxInsights : TaxInsightViewModel
    @Binding var isStoryTrip : Bool
    @Binding var selectedTab : Int
    var body: some View {
        ZStack(alignment: .top){
            Color.gray1.ignoresSafeArea()
            VStack(spacing: 0){
                HStack(spacing: 20){
                    Image(!taxInsights.tasksInComplete.isEmpty ? "alert-circle" : "completedIcon")
                    VStack(alignment: .leading, spacing: 4){
                        Text(!taxInsights.tasksInComplete.isEmpty ? "Action required" : "All Done").textCase(.uppercase)
                            .foregroundColor(.gray6)
                            .font(.VialtoRegular12)
                        
                        Text(!taxInsights.tasksInComplete.isEmpty ? "\(taxInsights.tasksInComplete.count) Tasks outstanding" : "\(taxInsights.tasksComplete.count) Tasks Complete").font(.VialtoMedium16)
                            .foregroundColor(!taxInsights.tasksInComplete.isEmpty ? .statusRed4 : .statusGreen1)
                    }.onTapGesture {
                        self.selectedTab = 1
                    }
                    Spacer()
                    Image("left-arrow")
                }.padding(18).frame(maxWidth: .infinity, maxHeight: 71).background(Color.statusRed1)
                VStack(spacing: 0){
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(spacing: 34){
                            let value = taxInsights.viewSummaryData[0].taxReturnInfo?.filingDetails
                            ForEach(value!, id: \.self) { values in
                                VStack(alignment: .leading, spacing: 8){
                                    HStack{
                                        Text(values!.taxAuthority)
                                            .font(.VialtoBold20)
                                        if ((taxInsights.viewSummaryData[0].taxReturnInfo?.efile!.hasSigned)! || values!.markAsPaid) && values!.markAsFiled {
                                            HStack{
                                                Text("All actions completed").font(.VialtoRegular12).foregroundColor(.statusGreen4)
                                                Image("checkmark")
                                            }.padding(6).background(Color.statusGreen1).clipShape(Capsule())
                                        }
                                        
                                    }
                                    
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.gray3)
                                    
                                    FilingCard(filingType: values!.filingMethod.lowercased(), isBool: values!.filingMethod.lowercased() == "efile" ? values!.filingStatus == "Joint" ? taxInsights.viewSummaryData[0].taxReturnInfo?.efile!.hasJointSigned ?? false : taxInsights.viewSummaryData[0].taxReturnInfo?.efile!.hasSigned ?? false : values!.markAsFiled, date: "\(values!.actionDueDate!)", spouse: values!.filingStatus, status: taxInsights.viewSummaryData[0].milestones[2].status.rawValue)

                                    if values!.refundOrPaymentDue != 0 {
                                        PaymentCard(value: values!.refundOrPaymentDue, isBool: values!.markAsPaid, link: values!.refundLink)
                                    }
                                    
                                }
                            }
                        }.padding(.vertical, 24).frame(width: UIScreen.main.bounds.width-64)
                    }
                    Spacer()
                }.frame(maxWidth: .infinity).background(Color.primaryWhite)
                VStack{
                    Text("View Tax Return").font(.VialtoMedium16)
                        .frame(width: UIScreen.main.bounds.width-64, height: 40)
                        .background(Color.primaryTeal)
                        .clipShape(Capsule())
                    HStack{
                        Text("Replay My Tax Return Story").font(.VialtoMedium12).foregroundColor(.secondaryMedTeal)
                            .frame(height: 20)
                        Image("play")
                    }.onTapGesture {
                        self.isStoryTrip = true
                    }
                }.frame(height: 104)
            }
        }
    }
}

//struct MyTaxReturnView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyTaxReturnView(modelData: TaxInsightViewModel().viewSummaryData[0], isStoryTrip: .constant(false))
//    }
//}

struct FilingCard : View{
    @State var filingType : String
    @State var isBool : Bool
    @State var date : String
    @State var spouse : String
    @State var status : Int
    var body: some View{
        VStack(alignment: .leading, spacing: 2){
            HStack{
                Image((filingType == "efile" ? isBool && status == 2 : isBool) ? "checkmark-circle" : isBool && status == 1 ? "progressIcon" : "alert-circle-bold")
        
                Text(filingType == "efile" ? "\(spouse == "Joint" ? "Spouse " : "")E-File Consent Required" : "Paper Filing Required").font(.VialtoRegular14)
                Spacer()
            }
            if (filingType == "efile" ? isBool && status == 2 : isBool){
                Text("Marked as \(filingType.lowercased()) on \(date)").font(.VialtoRegular12).foregroundColor(.gray6)
                    .frame(width: 213, alignment: .leading)
            }
        }
    }
}

struct PaymentCard : View{
    @State var value : Int
    @State var isBool : Bool
    @State var link : String?
    var body: some View{
        VStack(alignment: .leading, spacing: 2){
            HStack{
                Image(isBool ? "info" : "alert-circle-bold" )
                
                Text( "**\(abs(value)) USD** \(value < 0 ? "Payment Due" : "Refund")").font(.VialtoRegular14)
                Spacer()
                if value > 0 {
                    Link(destination: URL(string: link ?? "")!) {
                        Text("Track refund").font(.VialtoMedium12)
                            .foregroundColor(.secondaryMedTeal)
                        Image("arrow-up-right")
                    }
                }
            }
            if value != 0 {
                Text(value < 0 ? "This payment due will be made by your employer" : "This payment will be direct debited from your account").font(.VialtoRegular12).foregroundColor(.gray6)
                    .frame(width: 213, alignment: .leading)
            }
        }
    }
}
