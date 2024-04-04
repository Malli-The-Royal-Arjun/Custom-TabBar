//
//  TaxSummaryPaperfileView.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 16/04/23.
//

import SwiftUI

struct PaymentCompleteModel{
    var title, descrption, dueDate, buttonName : String
}

struct TaxSummaryPaperfileView: View {
    @State var efileModel : PaymentCompleteModel
    @State var isfiled : Int = 0
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
                    Image(isfiled >= 2 ? "completedIcon" : "calendarIcon")
                    Text(efileModel.dueDate)
                    
                }.foregroundColor(isfiled >= 2 ? .statusGreen4 : .statusRed4)
                
                VStack(alignment: .leading, spacing: 16){
                    Text("How to Paper File")
                        .font(.VialtoBold16)
                    Text(efileModel.descrption)
                        
             
                    Text("City of Cincinnati Income Tax Division \n P.O. Box 637876 \n Cincinnati, OH 45263-7876").padding(.leading, 16).frame(maxWidth: .infinity, maxHeight: 92, alignment: .leading).background(Color.gray1).cornerRadius(5)
                    
                    Text("Additional details can be found in your tax return documents.")
                    
                    HStack{
                        Text("View tax return")
                        Image("arrow-up-right")
                    }.foregroundColor(.secondaryMedTeal)
                    
                    Text("Once mailed please upload a copy of your mailing and payment receipts (if applicable) to your Documents section.")
                    
                }.lineSpacing(3)
                Spacer()
                
                VStack{
                    Button(action:{
                        if isfiled == 0{
                            self.isfiled = 1
                        }else if isfiled == 2{
                            self.isfiled = 3
                        }
                    }){
                        Text(isfiled >= 2 ? "Filed" : "Mark as filed").font(.VialtoMedium16)
                            .frame(maxWidth: .infinity, maxHeight: 40)
                            .foregroundColor(isfiled >= 2 ? .primaryWhite : .primaryBlack)
                    }.background(isfiled >= 2 ? Color.statusGreen3 : Color.primaryTeal).cornerRadius(5)
                    
                    HStack{
                        Text("Upload mailing receipt")
                        Image("upload-Icon")
                    }.frame(maxWidth: .infinity, maxHeight: 40)
                        .foregroundColor(.secondaryMedTeal)
                }
            }.frame(width: UIScreen.main.bounds.width-32, alignment: .leading).font(.VialtoRegular14).foregroundColor(.primaryBlack)
            if isfiled == 1 ||  isfiled == 3{
                AlertCard(label: isfiled == 1 ? "Mark as filed" : "Undo Mark as Filed?", descrption: isfiled == 1 ? "“Mark as filed” for your reference only. Completing this action does not notify the tax authorities about a tax return filing you may have made." : "You have marked this task as complete. Click Confirm to undo “Mark as filed” and move this task to outstanding. ", isBool: $isfiled)
            }
    
        }.navigationBarHidden(true)
    }
}

struct TaxSummaryPaperfileView_Previews: PreviewProvider {
    static var previews: some View {
        TaxSummaryPaperfileView(efileModel: PaymentCompleteModel(title: "Complete Paper Filing for Ohio", descrption: "Your tax return is ready for review. Complete the E-Sign process, to authorize Vialto Partners to submit your tax return(s) eligible for E-File on your behalf.", dueDate: "Action required by 20 Jan 2023", buttonName: "Mark as filed"))
    }
}

struct AlertCard: View{
    @State var label : String
    @State var descrption : String
    @Binding var isBool : Int
    var body: some View{
        ZStack{
            Color.primaryWhite.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 0){
                Spacer()
                Text(label)
                    .font(.VialtoBold16)
                Spacer()
                Text(descrption)
                    .padding(8)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                Spacer()
                VStack(spacing: 0){
                    Divider()
                    HStack(spacing:0){
                        Spacer()
                        Button(action: {
                            if isBool == 1{
                                self.isBool = 0
                            }else if isBool == 3{
                                self.isBool = 2
                            }
                        }){
                            Text("Cancel")
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        Button(action: {
                            if isBool == 1{
                                self.isBool = 2
                            }else if isBool == 3{
                                self.isBool = 0
                            }
                        }){
                            Text("Confirm")
                                .foregroundColor(.secondaryMedTeal)
                        }
                        Spacer()
                    }.frame(height: 48)
                }
            } .font(.VialtoRegular14)
                .frame(width: UIScreen.main.bounds.width-46, height: 188.33)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray1, lineWidth: 2))
                .shadow(color: .gray1, radius: 5, x: 2, y: 2)
                .background(Color.primaryWhite).cornerRadius(10).foregroundColor(.primaryBlack)
        }
    }
}
