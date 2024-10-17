//
//  HorizontalFoodScrollView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/23/24.
//

import SwiftUI

struct HorizontalScrollView: View {
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @GestureState private var translation: CGFloat = 0
    @Binding var reviews: [ReviewData]
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(reviews, id: \.self) { review in
                        ZStack {
                            FoodCardView(reviewData: review, path: $path)
                                .frame(width: geometry.size.width)
                        }
                    }
                }
                .offset(x: -CGFloat(currentIndex) * geometry.size.width + offset + translation)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            state = value.translation.width
                            print("Dragging: \(value.translation.width)")
                        }
                        .onEnded { value in
                            let threshold: CGFloat = geometry.size.width * 0.1
                            let predictedEndOffset = value.predictedEndTranslation.width

                            print("Predicted End Offset: \(predictedEndOffset)")

                            if predictedEndOffset < -threshold {
                                currentIndex = min(currentIndex + 1, reviews.count - 1)
                            } else if predictedEndOffset > threshold {
                                currentIndex = max(currentIndex - 1, 0)
                            }

                            offset = 0
                        }
                )
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: translation)
            }
            .frame(height: 300)
            .clipped()

            PageControl(numberOfPages: reviews.count, currentIndex: $currentIndex)
                .padding(.top, 0)
        }
    }
}
