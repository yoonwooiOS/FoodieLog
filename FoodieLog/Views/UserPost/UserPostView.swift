//
//  FolderView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import SwiftUI
import RealmSwift

struct UserPostView: View {
    @State private var reviews: [Review] = []
    let realmRepository = ReviewRepository()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorSet.primary.color
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("저장한 리뷰")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(reviews) { review in
                                ReviewCardView(review: review)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                fetchReviews()
            }
            .navigationBarHidden(true)
        }
    }
    
    private func fetchReviews() {
        reviews = realmRepository.fetchAll()
    }
}

struct ReviewCardView: View {
    let review: Review
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            reviewImage
            
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                Text(review.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(review.restaurantName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    dateView
                    Spacer()
                    ratingView
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var reviewImage: some View {
        Group {
            if let imagePath = review.imagePaths.first,
               let uiImage = ImageManager.shared.loadImageFromDisk(imageName: imagePath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Color.gray
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
    
    private var ratingView: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.caption)
            Text(review.rating.oneDecimalString)
                .font(.caption)
        }
    }
    
    private var dateView: some View {
        Text(formattedDate(review.date))
            .font(.caption)
            .foregroundColor(.secondary)
    }
}
