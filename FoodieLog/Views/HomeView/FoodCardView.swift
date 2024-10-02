//
//  FoodCardView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI

struct FoodCardView: View {
    let review: Review
    @State private var rating: Double
    @State private var loadedImage: UIImage? = nil
    @State private var isNavigationActive = false
    
    init(review: Review) {
        self.review = review
        _rating = State(initialValue: review.rating)
    }
    var body: some View {
        ZStack {
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 250)
                    .cornerRadius(20)
                    .overlay(
                        overlayContent,
                        alignment: .bottom
                    )
                
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: 350, height: 250)
                    .cornerRadius(20)
            }
        }
        .padding()
        .onTapGesture {
            isNavigationActive = true
        }
        .background(
            NavigationLink(
                destination: DetailView(review: review),
                isActive: $isNavigationActive,
                label: { EmptyView() }
            )
        )
        .onAppear {
            loadImage()
        }
    }
    
    private var overlayContent: some View {
        VStack(alignment: .center, spacing: 5) {
            Spacer()
            HStack {
                Spacer()
                //MARK: 카테고리
                //                Label("한식", systemImage: "person")
                //                Image(systemName: "fork.knife")
                //                    .font(.caption)
                //                    .foregroundColor(.gray)
                Text(review.restaurantName)
                    .foregroundStyle(.black)
                    .font(.headline)
                Spacer()
            }
            HStack {
                RatingView(rating: $rating, starSize: 20)
                    .frame(width: 100)
            }
            Spacer()
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(20)
        .frame(width: 260, height: 80)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.bottom, -18)
    }
    
    private func loadImage() {
        if let firstImagePath = review.imagePaths.first {
            print("Attempting to load image from path: \(firstImagePath)")
            loadedImage = ImageManager.shared.loadImageFromDisk(imageName: firstImagePath)
            
            if loadedImage == nil {
                print("Failed to load image from path: \(firstImagePath)")
            } else {
                print("Image loaded successfully from path: \(firstImagePath)")
            }
        } else {
            print("No image path found in review.imagePaths")
        }
    }
}
