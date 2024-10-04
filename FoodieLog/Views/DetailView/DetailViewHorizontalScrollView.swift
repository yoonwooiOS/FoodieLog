//
//  DetailViewHorizontalScrollView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/3/24.
//

import SwiftUI

struct DetailViewHorizontalScrollView: View {
    @Binding var currentIndex: Int
    @State private var reviewImages: [Image] = []
    @State private var offset: CGFloat = 0
    @GestureState private var translation: CGFloat = 0
    var review: ReviewData
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    ForEach(reviewImages.indices, id: \.self) { index in
                        reviewImages[index]
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: 300)
                        
                            .clipped()
                    }
                }
                .offset(x: -CGFloat(currentIndex) * geometry.size.width + offset + translation)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: offset)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: translation)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            let threshold: CGFloat = geometry.size.width * 0.1
                            if value.translation.width < -threshold {
                                currentIndex = min(currentIndex + 1, reviewImages.count - 1)
                            } else if value.translation.width > threshold {
                                currentIndex = max(currentIndex - 1, 0)
                            }
                            offset = 0
                        }
                )
                PageControl(numberOfPages: reviewImages.count, currentIndex: $currentIndex)
                    .padding(.top, 8)
            }
        
        }
        .clipped()
        .task {
            loadImages()
        }
    }
    
    private func loadImages() {
        reviewImages = review.imagePaths.compactMap { imagePath in
            ImageManager.shared.loadImageFromDisk(imageName: imagePath)
        }.map { Image(uiImage: $0) }
    }
}
