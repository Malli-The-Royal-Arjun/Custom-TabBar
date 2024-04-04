//
//  TaxsummaryView.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 26/05/23.
//

import SwiftUI

struct TaxsummaryView: View {
    var body: some View {
        TaxStoryWelcomhge()
        TaxStoryCheckTnnnasks()
            .foregroundColor(.white)
        TaxStoryActionCard()
    }
}

struct TaxsummaryView_Previews: PreviewProvider {
    static var previews: some View {
        TaxsummaryView()
    }
}

struct TaxStoryWelcomhge: View {
    var body: some View {
            ZStack(alignment: .top){
                Color.secondaryDarkTeal
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                        .frame(maxHeight: 30)
                    Text("Your 2022 United States\nTax Returns are ready")
                        .font(.VialtoBold24).fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Image("vector")
                    Spacer()
                    Text("your_personalized_label").fixedSize(horizontal: false, vertical: true)
                        .font(.VialtoBold20)
                    Spacer()
                    Image("Man WFH_RGB_Teal")
                    Spacer()
                }.multilineTextAlignment(.center).lineSpacing(2)
                    .frame(width: UIScreen.main.bounds.width-32)
                    .background(alignment: .topLeading){
                        Text("Welcome Kayla!").font(.VialtoBold16)
                    }
                    .background(alignment: .bottom){
                        Image("Dot1")
                    }
            }.foregroundColor(.primaryWhite)
    }
}

struct TaxStoryCheckTnnnasks: View {
    var body: some View {
        ZStack(alignment: .top){
            Color.secondaryDarkTeal
                .ignoresSafeArea()
            VStack(alignment: .leading){
                Spacer()
                    .frame(maxHeight: 30)
                Text("Here’s what you need to do to complete your taxes this year").font(.VialtoBold24)
                    .frame(width: UIScreen.main.bounds.width-64)
                ScrollView(.vertical, showsIndicators: false){
                VStack(alignment: .leading, spacing: 32){
                    OutstandingTasksCard(image: "reviewIcon", label: "Review your tax return", view: AnyView(EmptyView()))
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width-36, height: 1).opacity(0.5)
                    OutstandingTasksCard(image: "filingIcon", label: "Complete tax filing", view: AnyView(
                        VStack(alignment: .leading, spacing: 16){
                            OutstandingCard(label: "Complete E-File consent for", chips: ["Federal", "FBAR", "California", "Michigan", "Ohio", "Massachusetts"])
                            OutstandingCard(label: "Paper file the tax return for", chips: ["California"])
                        }
                    ))
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width-36, height: 1).opacity(0.5)
                    
                    OutstandingTasksCard(image: "paymentIcon", label: "Make payments ", view: AnyView(
                        OutstandingCard(label: "Pay balance due for", chips: ["California"])
                    ))
                }.padding(.vertical, 32)
            }
                Spacer()
            }.frame(width: UIScreen.main.bounds.width-32)
                .background(alignment: .bottom){
                    VStack{
                        Image("stroy3-1")
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                        Image("Dot2")
                    }
                }
                .background(alignment: .top){
                    Image("stroy3")
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                        .edgesIgnoringSafeArea(.top)
                }
        }
    }
}

struct OutstandingTasksCard: View{
    @State var image : String
    @State var label : String
    @State var view : AnyView
    var body: some View{
        VStack(alignment: .leading, spacing: 16){
            HStack(spacing: 16){
                Image(image)
                Text(label).font(.VialtoBold20)
            }
            view.padding(.leading)
        }
    }
}

struct OutstandingCard: View{
    @State var label : String
    @State var chips : [String]
    var body: some View{
        HStack(alignment: .top, spacing: 16){
            Image("smallVector").renderingMode(.template).foregroundColor(.primaryLightTeal)
            VStack(alignment: .leading, spacing: 8){
                Text(label)
                WrappingHStack(horizontalSpacing: 8) {
                    ForEach(chips, id: \.self){ chip in
                        CapsuleCard(label: chip, color: .constant([.primaryBlack, .primaryLightTeal]), font: .VialtoRegular16, insets: [6, 12, 6, 12 ])
                    }
                }
            }
        }
    }
}

struct TaxStoryActionCard: View {
    @State var images = ["trackIcon", "manageIcon", "gainIcon"]
    var body: some View {
        ZStack{
            Color.secondaryDarkTeal
                .ignoresSafeArea()
            VStack(alignment: .leading){
                Spacer()
                    .frame(maxHeight: 30)
                HStack(alignment: .top){
                    Text("explore_dashboard")
                        .font(.VialtoBold24)
                        .padding(.leading, 32)
                    Image("guy_door_stroke").renderingMode(.template).foregroundColor(.primaryLightTeal)
                }.fixedSize(horizontal: false, vertical: true)
               Spacer()
                ForEach(self.images, id: \.self){index in
                    HStack(spacing: 22){
                        Image(index)
                        Text("track_progress") .font(.VialtoBold20).lineLimit(2)
                    }.frame(width: UIScreen.main.bounds.width-96)
                }.fixedSize(horizontal: false, vertical: true)
                Spacer()
                Button(action:{
                    
                }){
                    Text("Let’s do it!").foregroundColor(.primaryBlack)
                        .font(.VialtoMedium16)
                        .frame(width: UIScreen.main.bounds.width-163, height: 51)
                        .background(Color.primaryTeal)
                        .clipShape(Capsule())
                }.frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 30)
            }.background(alignment: .bottom){
                Image("Dot3")
            }
            
        }.foregroundColor(.primaryWhite)
    }
}

struct CapsuleCard: View{
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

private struct WrappingHStack: Layout {
    private var horizontalSpacing: CGFloat
    private var verticalSpacing: CGFloat
    public init(horizontalSpacing: CGFloat, verticalSpacing: CGFloat? = nil) {
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing ?? horizontalSpacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        guard !subviews.isEmpty else { return .zero }

        let height = subviews.map { $0.sizeThatFits(proposal).height }.max() ?? 0

        var rowWidths = [CGFloat]()
        var currentRowWidth: CGFloat = 0
        subviews.forEach { subview in
            if currentRowWidth + horizontalSpacing + subview.sizeThatFits(proposal).width >= proposal.width ?? 0 {
                rowWidths.append(currentRowWidth)
                currentRowWidth = subview.sizeThatFits(proposal).width
            } else {
                currentRowWidth += horizontalSpacing + subview.sizeThatFits(proposal).width
            }
        }
        rowWidths.append(currentRowWidth)

        let rowCount = CGFloat(rowWidths.count)
        return CGSize(width: max(rowWidths.max() ?? 0, proposal.width ?? 0), height: rowCount * height + (rowCount - 1) * verticalSpacing)
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let height = subviews.map { $0.dimensions(in: proposal).height }.max() ?? 0
        guard !subviews.isEmpty else { return }
        var x = bounds.minX
        var y = height / 2 + bounds.minY
        subviews.forEach { subview in
            x += subview.dimensions(in: proposal).width / 2
            if x + subview.dimensions(in: proposal).width / 2 > bounds.maxX {
                x = bounds.minX + subview.dimensions(in: proposal).width / 2
                y += height + verticalSpacing
            }
            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .center,
                proposal: ProposedViewSize(
                    width: subview.dimensions(in: proposal).width,
                    height: subview.dimensions(in: proposal).height
                )
            )
            x += subview.dimensions(in: proposal).width / 2 + horizontalSpacing
        }
    }
}
