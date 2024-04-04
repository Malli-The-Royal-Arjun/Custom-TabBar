//
//  TasksView.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 14/03/23.
//

import SwiftUI

struct TasksModel: Codable {
    var image : String
    var imageName : String
    var chips : [String]
    var taskName: String
    var taskDueDate: String
}

struct TasksView: View {
    @ObservedObject var taxInsights : TaxInsightViewModel
   @State var isExpanded: Bool
    var body: some View {
        ZStack{
            Color.gray1.ignoresSafeArea()
         
            ScrollView (.vertical, showsIndicators: false) {
                VStack(spacing: 16){
                    if self.taxInsights.tasksInComplete.count == 0{
                        VStack(spacing: 32){
                            Text("Tasks")
                                .font(.VialtoBold24)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Well done! You are all caught up.").font(.VialtoMedium14)
                                .foregroundColor(.gray6)
                            Image("nilTasks")
                        }
                        
                    }else{
                        ForEach(0..<self.taxInsights.tasksInComplete.count, id: \.self) { item in
                            TasksCardView(data: self.taxInsights.tasksInComplete[item], color: .primaryWhite)
                        }
                    }
                    if self.taxInsights.tasksComplete.count != 0 {
                        Divider()
                        HStack {
                            Text("\(isExpanded ? "Hide" : "Show") completed Tasks (\(self.taxInsights.tasksComplete.count))").font(.VialtoMedium14)
                            Image("left-arrow").renderingMode(.template).rotationEffect(.degrees(isExpanded ? 270 : 90))
                        }.foregroundColor(.secondaryMedTeal).onTapGesture {
                            self.isExpanded.toggle()
                        }
                        
                        if isExpanded{
                            ForEach(0..<self.taxInsights.tasksComplete.count, id: \.self) { item in
                                TasksCardView(data: self.taxInsights.tasksComplete[item], color: .statusGreen1)
                            }
                        }
                    }
                }.padding([.horizontal, .top])
            }
        }.foregroundColor(.primaryBlack)
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(taxInsights: TaxInsightViewModel(), isExpanded: false)
    }
}

struct TasksCardView: View {
    @State private var selection: String? = nil
    @State var data : TasksModel
    @State var color : Color
    var body: some View {
        NavigationLink(destination: TaxSummaryPaperfileView(efileModel: PaymentCompleteModel(title: "Complete Paper Filing for Ohio", descrption: "Your tax return is ready for review. Complete the E-Sign process, to authorize Vialto Partners to submit your tax return(s) eligible for E-File on your behalf.", dueDate: "Action required by 20 Jan 2023", buttonName: "Mark as filed")), tag: "CompleteScreen", selection: $selection){
        HStack{
            VStack(alignment: .center, spacing: 10) {
                Image(data.image)
                    .frame(width: 22, height: 30)
                Text(data.imageName).font(.VialtoRegular12)
                    .foregroundColor(color == .statusGreen1 ? .statusGreen4 : .gray6)
            }.padding(.leading, 4).frame(width: 74, alignment: .center)
            
            Divider()
            VStack(alignment: .leading, spacing: 6) {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(data.chips, id: \.self){value in
                            CapuslLabel(label: value, color: .constant([.primaryBlack, color == .statusGreen1 ? .gray2 : .statusBlue2]), font: .VialtoRegular12, insets: [5, 8, 5, 8])
                        }
                    }
                }
                Text(data.taskName)
                    .font(.VialtoMedium14)
                HStack {
                    Image("calendarIcon")
                    Text(data.taskDueDate)
                }.foregroundColor(color == .statusGreen1 ? .statusGreen4 : .statusRed4)
            }.padding(16).frame(maxWidth: .infinity, alignment: .leading)
                .font(.VialtoRegular12)
            Image("left-arrow")
                .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 94, maxHeight: 94)
        .background(color)
        .cornerRadius(5)
        .overlay(RoundedRectangle(cornerRadius: 5)
            .stroke(Color.gray3, lineWidth: 1))
        .shadow(color: .gray3, radius: 2, x: 0, y: 2)
        .onTapGesture {
            self.selection = "CompleteScreen"
        }
    }
    }
}
