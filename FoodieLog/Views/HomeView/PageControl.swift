//
//  PageControl.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/30/24.
//

import SwiftUI

struct PageControl: View {
    let numberOfPages: Int
    @Binding var currentIndex: Int
    let dotSize: CGFloat = 8
    let dotSpacing: CGFloat = 12
    let primaryColor: Color = .black
    let secondaryColor: Color = .gray
    
    var body: some View {
        HStack(spacing: dotSpacing) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? primaryColor : secondaryColor)
                    .frame(width: dotSize, height: dotSize)
            }
        }
    }
}
