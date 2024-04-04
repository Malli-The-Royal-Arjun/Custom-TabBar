//
//  LoadingRectangle.swift
//  CustomTopTabBar
//
//  Created by Mupparaju M Rao TPR on 08/03/23.
//

import SwiftUI

struct LoadingRectangle: View {
    
    var progress:CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray4)
                    .cornerRadius(5)
                Rectangle()
                    .frame(width: geometry.size.width * self.progress, height: nil, alignment: .leading)
                    .foregroundColor(Color.primaryTeal)
                    .cornerRadius(5)
            }
        }
    }
}

struct LoadingRectangle_Previews: PreviewProvider {
    static var previews: some View {
        LoadingRectangle(progress: 0.7)
    }
}
