//
//  HorizontalFoodScrollView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/23/24.
//

import SwiftUI

struct HorizontalScrollView: View {
    let items = Array(0..<5)
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(items, id: \.self) { index in
                    FoodCardView()
                        .frame(width: geometry.size.width * 0.9)
                        .padding(.horizontal, geometry.size.width * 0.05)
                }
            }
            .offset(x: -CGFloat(currentIndex) * geometry.size.width + offset + translation)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentIndex)
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = geometry.size.width * 0.1 
                        if value.translation.width < -threshold {
                            currentIndex = min(currentIndex + 1, items.count - 1)
                        } else if value.translation.width > threshold {
                            currentIndex = max(currentIndex - 1, 0)
                        }
                        offset = 0 
                    }
            )
        }
        .frame(height: 300)
        .clipped()
    }
}

#Preview {
    HorizontalScrollView()
}
