//
//  FolderView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import SwiftUI
import RealmSwift

enum SortOption: String, CaseIterable {
    case latest = "최신순"
    case highestRated = "별점 높은순"
    case lowestRated = "별점 낮은순"
}

struct UserPostView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = UserPostViewModel()
    @State private var selectedSortOption: SortOption = .latest
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorSet.primary.color.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("등록한 리뷰")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        HStack(spacing: 8) {
                            Text(selectedSortOption.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Menu {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Button(option.rawValue) {
                                        selectedSortOption = option
                                        viewModel.action(.sortRequested(option))
                                    }
                                }
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    
                    ScrollView {
                        if viewModel.output.isLoading {
                            ProgressView("로딩중..")
                                .padding()
                        } else if viewModel.output.reviews.isEmpty {
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
                                ForEach(viewModel.output.reviews, id: \.id) { review in
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
            .onAppear {
                viewModel.action(.viewAppeared)
            }
            .onChange(of: path) { _ in
                viewModel.action(.refreshRequested)
            }
            .navigationBarHidden(true)
        }
    }
}
struct ReviewCardView: View {
    let review: ReviewData
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            reviewImage
            
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                HStack(spacing: 4) {
                    Text(review.title)
                        .font(.headline)
                        .foregroundStyle(.black)
                        .lineLimit(1)
                    Spacer()
                    Text(review.category)
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
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
        //        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
