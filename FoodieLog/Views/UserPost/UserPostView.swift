//
//  FolderView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import SwiftUI
import RealmSwift

struct UserPostView: View {
    @Binding var path: NavigationPath
    @State private var reviews: [ReviewData] = []
    let realmRepository = ReviewRepository()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("등록한 리뷰")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                    
                    ScrollView {
                        if reviews.isEmpty {
                            VStack {
                                Spacer()
                                Text("등록한 리뷰가 없습니다.")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        } else {
                            LazyVStack(alignment: .leading, spacing: 16) {
                                ForEach(reviews, id: \.id) { review in
                                    NavigationLink(destination: DetailView(reviewData: review, path: $path)) {
                                        ReviewCardView(review: review)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(ColorSet.primary.color)
            .onAppear {
                fetchReviews()
            }
            .onChange(of: path) { _ in
                           fetchReviews()
                       }
            .navigationBarHidden(true)
        }
    }
    
    private func fetchReviews() {
        reviews = realmRepository.fetchAll().map { ReviewData(from: $0) }
    }
}

struct ReviewCardView: View {
    let review: ReviewData
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            reviewImage
            
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                Text(review.title)
                    .font(.headline)
                    .foregroundStyle(.black)
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
                .foregroundColor(.black)
                .font(.caption)
        }
    }
    
    private var dateView: some View {
        Text(formattedDate(review.date))
            .font(.caption)
            .foregroundColor(.secondary)
    }
}
