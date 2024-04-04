//
//  ViewTaxReturnPage.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 17/04/23.
//

import SwiftUI

struct ViewTaxReturnPage: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color.primaryWhite
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 32){
                VStack(alignment: .leading, spacing: 12){
                    HStack{
                        Image("left-arrow").renderingMode(.template).rotationEffect(.degrees(180))
                        Text("Back")
                    }.font(.VialtoRegular16).foregroundColor(.secondaryMedTeal).onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    Text("My Tax Return Documents")
                        .font(.VialtoBold32)
                    Text("2022 United States")
                        .font(.VialtoBold20)
                }.padding(.horizontal, 16)
                    VStack(alignment: .leading, spacing: 16){
                        ScrollView(.vertical, showsIndicators: true){
                            ForEach(0..<2, id: \.self){ _ in
                                DocumentCard(doumentCount: 3)
                            }
                        }
                        Spacer()
                    }.padding(.horizontal, 16).frame(maxWidth: .infinity, alignment: .leading).background(Color.gray1)
                }
            .font(.VialtoRegular14).foregroundColor(.primaryBlack)
        }
    }
}

struct ViewTaxReturnPage_Previews: PreviewProvider {
    static var previews: some View {
        ViewTaxReturnPage()
    }
}

struct DocumentCard:View{
    @State var doumentCount: Int
    var body: some View{
        Text("Tax Returns".uppercased())
            .font(.VialtoMedium12).foregroundColor(.gray6)
            .padding(.top, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
        ForEach(0..<doumentCount, id: \.self){ _ in
            HStack(spacing: 16){
                Image("efileIcon").resizable().frame(width: 31, height: 33)
                VStack(alignment: .leading, spacing: 4){
                    Text("2022 US Tax Return")
                        .font(.VialtoBold14).foregroundColor(.secondaryMedTeal)
                    Text("Uploaded Mar 07 | 104 KB")
                        .font(.VialtoRegular10).foregroundColor(.gray6)
                }
            }.padding(12).frame(maxWidth: .infinity, alignment: .leading).background(Color.primaryWhite).cornerRadius(12)
        }
    }
}
