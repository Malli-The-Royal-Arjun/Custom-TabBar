//
//  TaxSummaryEfileView.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 06/04/23.
//

import SwiftUI

struct EfileCompleteModel{
    var title, descrption, dueDate, buttonName : String
}

struct TaxSummaryEfileView: View {
    @State var efileModel : EfileCompleteModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color.primaryWhite
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 32){
                VStack(alignment: .leading, spacing: 12){
                    HStack{
                        Image("left-arrow").renderingMode(.template).rotationEffect(.degrees(180))
                        Text("Tasks")
                    }.font(.VialtoRegular16).foregroundColor(.secondaryMedTeal).onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    Text(efileModel.title)
                        .font(.VialtoBold32)
                }
                HStack {
                    Image("calendarIcon")
                    Text(efileModel.dueDate)
                    
                }.foregroundColor(.statusRed4)
                
                Text(efileModel.descrption)
                    .lineSpacing(3)
                Spacer()
                
                Button(action:{
                    
                }){
                    Text(efileModel.buttonName).font(.VialtoMedium16)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }.background(Color.primaryTeal).cornerRadius(5)
            }.frame(width: UIScreen.main.bounds.width-32, alignment: .leading).font(.VialtoRegular14).foregroundColor(.primaryBlack)
        }.navigationBarHidden(true)
    }
}

struct TaxSummaryEfileView_Previews: PreviewProvider {
    static var previews: some View {
        TaxSummaryEfileView(efileModel: EfileCompleteModel(title: "Invite your spouse to complete E-File Consent for Federal, FBAR, California, Cincinnati, and Michigan", descrption: "Your tax return is ready for review. Complete the E-Sign process, to authorize Vialto Partners to submit your tax return(s) eligible for E-File on your behalf.", dueDate: "Action required by 20 Jan 2023", buttonName: "Complete E-Sign"))
    }
}
