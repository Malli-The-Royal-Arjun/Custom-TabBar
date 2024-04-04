//
//  CARDVIEW.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 26/04/23.
//

import SwiftUI

struct CARDVIEW: View {
    var body: some View {
        VStack{
            HStack{
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(maxWidth: .infinity, maxHeight: 112)
                        .foregroundColor(Color.primaryWhite)
                    
                        .shadow(color: .primaryBlack.opacity(0.25), radius: 4, x: 0, y: 4)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray3, lineWidth: 1))
                    VStack(alignment: .center, spacing: 10) {
                        Image("vector")
                        Text("label").multilineTextAlignment(.center)
                            .foregroundColor(.secondaryMedTeal).font(.VialtoMedium14)
                    }
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(maxWidth: .infinity, maxHeight: 112)
                        .foregroundColor(Color.primaryWhite)
                    
                        .shadow(color: .primaryBlack.opacity(0.25), radius: 4, x: 0, y: 4)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray3, lineWidth: 1))
                    VStack(alignment: .center, spacing: 10) {
                        Image("vector")
                        Text("label").multilineTextAlignment(.center)
                            .foregroundColor(.secondaryMedTeal).font(.VialtoMedium14)
                    }
                }
            }
        Spacer()
        }.padding()
    }
}

struct cardView_Previews: PreviewProvider {
    static var previews: some View {
        cardView()
    }
}

struct cardView: View{
    var body: some View{
        VStack(alignment: .center, spacing: 10) {
            Image("vector")
            Text("label").multilineTextAlignment(.center)
                .foregroundColor(.secondaryMedTeal).font(.VialtoMedium14)
        }
            
            .frame(maxWidth: .infinity, maxHeight: 112)
            .background(Color.primaryWhite)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(color: .primaryBlack.opacity(0.25), radius: 4, x: 0, y: 4)
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray3, lineWidth: 1)).padding()
    }
}
