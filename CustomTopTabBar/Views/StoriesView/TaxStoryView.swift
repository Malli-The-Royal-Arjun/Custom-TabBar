//
//  TaxStoryView.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 09/03/23.
//

import SwiftUI

struct TaxStoryView: View {
    @ObservedObject var storyTimer: StoryTimer
    var views : [AnyView] = [AnyView(TaxStoryWelcome()), AnyView(TaxStorySummary()), AnyView(TaxStoryCheckTasks()), AnyView(TaxStoryYear()), AnyView(TaxStoryResult()), AnyView(TaxStoryAction())]
//    @Binding var isStoryTrip : Bool
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                self.views[Int(self.storyTimer.progress)]
                HStack(alignment: .center, spacing: 4) {
                    ForEach(self.views.indices, id: \.self) { x in
                        LoadingRectangle(progress: min( max( (CGFloat(self.storyTimer.progress) - CGFloat(x)), 0.0) , 1.0) )
                            .frame(width: nil, height: 4, alignment: .leading)
                            .animation(.linear)
                    }
                }.padding(.horizontal)
                
                
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.storyTimer.advance(by: -1)
                    }
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
//                            if self.views.count-1 == Int(storyTimer.progress) {
//                                self.isStoryTrip = false
//                            }else{
                                self.storyTimer.advance(by: 1)
//                            }
                    }
                }
            }
            .onAppear { self.storyTimer.start() }
            .onDisappear {self.storyTimer.cancel() }

        }
    }
}

struct TaxStoryView_Previews: PreviewProvider {
    static var previews: some View {
        TaxStoryView(storyTimer: StoryTimer(items: 6, interval: 3.0, isStoryTrip: .constant(false)))
    }
}
struct TaxStoryWelcome: View {
    var body: some View {
        ZStack{
            Color.secondaryDarkTeal
                .ignoresSafeArea()
            VStack(spacing: 20){
                VStack{
                    Text("Hi Emily!").font(.VialtoBold16)
                        .frame(width: UIScreen.main.bounds.width-32, height: 40, alignment: .bottomLeading)
                    Spacer()
                    Text("Your 2022 United States\nTax Returns are ready")
                        .font(.VialtoBold24)
                    Spacer()
                    Image("vector")
                    Spacer()
                    Text("Let’s look at your personalized\ntax summary and actions\nfor this year")
                    Spacer()
                    Image("Man WFH_RGB_Teal")
                }.multilineTextAlignment(.center).lineSpacing(2)
                    .frame(width: UIScreen.main.bounds.width-32)
                Spacer()
                
                Image("group-vector")
                
            }.edgesIgnoringSafeArea(.bottom)
        }.foregroundColor(.primaryWhite)
    }
}

struct TaxStoryWelcome_Previews: PreviewProvider {
    static var previews: some View {
        TaxStoryWelcome()
    }
}

struct TaxStorySummary: View{
    var body: some View{
        ZStack{
            Image("mixedIcons").resizable().ignoresSafeArea()
            VStack{
                Spacer()
                    .frame(maxHeight: 67)
                Text("Here‘s a summary of your\n2022 United States Tax Returns").font(.VialtoMedium20)
                
                Spacer()
                
                
                HStack(spacing: 18){
                    rectagleCard(view: AnyView(VStack(alignment: .leading){
                        Text("Federal").font(.VialtoBold20)
                        Spacer()
                        Text("865 USD").font(.VialtoBold16).foregroundColor(.statusGreen3)
                        Text("Refund").font(.VialtoRegular12)
                    }.padding(20))).frame(width: UIScreen.main.bounds.width/3, height: 119)
                    
                    rectagleCard(view: AnyView(VStack(alignment: .leading){
                        Text("FBAR").font(.VialtoBold20)
                        Spacer().frame(minHeight: 0)
                        Text("865 USD")
                            .font(.VialtoBold16)
                            .foregroundColor(.statusGreen3)
                        Text("Report of Foreign Bank and Financial Accounts").font(.VialtoRegular12)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }.padding(20))).frame(width: UIScreen.main.bounds.width/2, height: 119)
                }.frame(width: UIScreen.main.bounds.width-48)
                
                
                Spacer()
                Spacer()
            }
        }
    }
}

struct TaxStoryYear: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.primaryBlack.opacity(0.8), .primaryBlack.opacity(0.5775), .primaryBlack.opacity(0.4621), .primaryBlack.opacity(0.337), .primaryBlack.opacity(0.08)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack{
                Spacer()
                    .frame(maxHeight: 67)
                Text("Your tax highlights for\nthis year").font(.VialtoMedium20)
                    .multilineTextAlignment(.center).foregroundColor(.primaryWhite)
                Spacer()
                VStack(spacing: 0){
                    VStack(spacing: 10){
                        Text("(1,044) USD")
                            .font(.VialtoBold24)
                        Text("Net amount out of pocket")
                            .font(.VialtoMedium20)
                    }.foregroundColor(.primaryBlack)
                    .frame(width: UIScreen.main.bounds.width-32, height: 156).background(Color.primaryWhite)
                    VStack(spacing: 32){
                        Image("vector").offset(y: -35)
//                        Spacer()
                        ForEach(0..<3){ id in
                            HStack{
                                Text("700 USD").foregroundColor(.tertiaryPink)
                                    .frame(width: (UIScreen.main.bounds.width-32)/2, alignment: .center)
                                VStack(alignment: .leading){
                                    if id == 2{
                                        Text("Tax reconciliation").textCase(.uppercase).font(.VialtoMedium12)
                                            .foregroundColor(.gray2)
                                    }
                                    Text("Tax payment(s)")
                                }
                                .frame(width: (UIScreen.main.bounds.width-32)/2, alignment: .leading)
                            }.font(.VialtoMedium20)
                        }
                        Spacer()
                        HStack(spacing: 5){
                                Text("View more in")
                                Text("Tax Insights").foregroundColor(.primaryTeal)
                            }.font(.VialtoMedium14)
                    }.padding(16).frame(width: UIScreen.main.bounds.width-32, height: 350).background(Color.primaryBlack)
                        .foregroundColor(.primaryWhite)
                }.cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryBlack, lineWidth: 1))
                
                Spacer()
            }
        }
    }
}

struct TaxStoryYear_Previews: PreviewProvider {
    static var previews: some View {
        TaxStoryYear()
    }
}

struct rectagleCard: View{
    @State var view: AnyView
    var body: some View{
        ZStack(alignment: .topLeading){
            RoundedRectangle(cornerRadius: 24)
                .foregroundColor(Color.primaryWhite)
                .overlay(RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray3, lineWidth: 1))
                .shadow(color: .gray3, radius: 5, x: 2, y: 2)
            view
        }
    }
}


struct CapuslLabel: View{
    @State var label : String
    @Binding var color : [Color]
    @State var font : Font
    @State var insets : [CGFloat]
    var body: some View{
        Text(label)
            .padding(EdgeInsets(top: insets[0], leading: insets[1], bottom: insets[2], trailing: insets[3]))
            .foregroundColor(color[0])
            .background(color[1])
            .clipShape(Capsule())
            .font(font)
    }
}


struct TaxStoryCheckTasks: View {
    var body: some View {
        ZStack(alignment: .top){
            VStack{
                Image("stroy3")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                Image("stroy3-1")
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                    
            }.ignoresSafeArea()
            
            VStack{
                Spacer()
                    .frame(maxHeight: 67)
                Text("Let’s check your\noutstanding tasks").font(.VialtoBold24)
                    .frame(width: UIScreen.main.bounds.width-64, alignment: .leading)
                Spacer()
                    .frame(maxHeight: 67)
                
                VStack(alignment: .leading, spacing: 16){
                    HStack(spacing: 16){
                        Image("filingIcon")
                        Text("FILING").font(.VialtoBold20)
                    }
                    Rectangle()
                        .frame(height: 1)
                        HStack(alignment: .top, spacing: 16){
                            Image("smallVector")
                            VStack(alignment: .leading, spacing: 4){
                            Text("Complete E-file consent for")
                                CapuslLabel(label: "Federal", color: .constant([.primaryBlack, .primaryTeal]), font: .VialtoRegular16, insets: [4, 12, 4, 12 ])
                        }
                    }
                }.frame(width: UIScreen.main.bounds.width-36, alignment: .leading)
                
                
                Spacer()
            }
        }
    }
}

struct TaxStoryCheckTasks_Previews: PreviewProvider {
    static var previews: some View {
        TaxStoryCheckTasks()
    }
}

struct TaxStoryResult: View {
    @State var effectarate = Array("23.23")
    var body: some View {
        ZStack(alignment: .top){
            VStack{
                Spacer()
                    .frame(maxHeight: 97)
                Group{
                    Text("Let’s look at what’s")
                    Text("impacting your results").background(Color.primaryTeal)
                }.font(.VialtoBold24)
                    .frame(width: UIScreen.main.bounds.width-64, alignment: .leading)
                Spacer()
                    .frame(maxHeight: 67)
                
                Text("Your effective tax rate".uppercased())
                    .font(.VialtoMedium13)
                Spacer().frame(maxHeight: 30)
                HStack(spacing: 8){
                    ForEach(0..<effectarate.count, id: \.self) { id in
                        Image(effectarate[id] == "." ? "dot" : String(effectarate[id])).renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
//                            .resizable().frame(width: 58, height: 84)
                       }
                    Image("percent").renderingMode(.template)
                        .resizable()
                        .frame(width: 77.21, height: 78)
                }.frame(maxWidth: UIScreen.main.bounds.width-32)
                Spacer().frame(maxHeight: 60)
                VStack(spacing: 0){
                        Text("What’s impacting my results")
                            .font(.VialtoRegular12).foregroundColor(.primaryWhite)
                    .frame(width: UIScreen.main.bounds.width-32, height: 36).background(Color.primaryBlack)
                    VStack(alignment: .leading){
                        Spacer()
                            .frame(maxHeight: 26)
                        Image("qutoe")
                        Spacer()
                            .frame(maxHeight: 26)
                        Text("You have a tax liability due on your sale of HSBC stock that created capital gains for you and your spouse within the tax year").font(.VialtoMedium14)
                    }.padding(16).frame(width: UIScreen.main.bounds.width-32, height: 182, alignment: .leading).background(Color.primaryWhite)
                }.cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryBlack, lineWidth: 1))
                    .shadow(color: .primaryBlack, radius: 2, x: 0, y: 2)
                Spacer()
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).background(alignment: .topLeading){
                Image("Ellipse-pink")
            }
            .background(alignment: .bottomTrailing){
                Image("Ellipse-blue")
            }.ignoresSafeArea()
        }
    }
}

struct TaxStoryResult_Previews: PreviewProvider {
    static var previews: some View {
        TaxStoryResult()
    }
}

struct TaxStoryAction: View {
    @State var images = ["trackIcon", "manageIcon", "gainIcon"]
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.primaryBlack, .primaryBlack.opacity(0.7)]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            VStack(spacing: 40){
                Spacer()
                Text("There’s more to explore in\nyour 2022 United States\nTax Return Dashboard")
                    .font(.VialtoBold24).multilineTextAlignment(.center)
                Spacer()
                ForEach(self.images, id: \.self){index in
                    HStack(spacing: 22){
                        Image(index)
                        Text("Track your tax return progress") .font(.VialtoBold24).lineLimit(2)
                    }.frame(width: UIScreen.main.bounds.width-96)
                }
                Spacer()
                    Text("Let’s get started").foregroundColor(.primaryBlack)
                        .frame(width: 205, height: 51)
                        .background(Color.primaryTeal)
                        .clipShape(Capsule())
                Spacer()
            }
        }.foregroundColor(.primaryWhite)
    }
}

struct TaxStoryAction_Previews: PreviewProvider {
    static var previews: some View {
        TaxStoryAction()
    }
}

