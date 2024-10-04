//
//  FoodCardView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI

struct FoodCardView: View {
    let reviewData: ReviewData
    @Binding var path: NavigationPath
    @State private var rating: Double
    @State private var loadedImage: UIImage? = nil
    @State private var isNavigationActive = false
    
    init(reviewData: ReviewData, path: Binding<NavigationPath>) {
        self.reviewData = reviewData
        _rating = State(initialValue: reviewData.rating)
        self._path = path
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
                    NavigationLink(destination: DetailView(reviewData: reviewData, path: $path), isActive: $isNavigationActive) {
                        EmptyView()
                    }
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
                Text(reviewData.restaurantName)
                    .foregroundStyle(.black)
                    .font(.headline)
                Spacer()
            }
            HStack {
                RatingView(rating: $rating, starSize: 20, isInteractive: false)
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
        DispatchQueue.global(qos: .background).async {
            if let firstImagePath = self.reviewData.imagePaths.first {
                print("Attempting to load image from path: \(firstImagePath)")
                if let image = ImageManager.shared.loadImageFromDisk(imageName: firstImagePath) {
                    DispatchQueue.main.async {
                        self.loadedImage = image
                        print("Image loaded successfully from path: \(firstImagePath)")
                    }
                } else {
                    print("Failed to load image from path: \(firstImagePath)")
                }
            } else {
                print("No image path found in reviewData.imagePaths")
            }
        }
    }
}
