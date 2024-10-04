//
//  HomeView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI


struct HomeView: View {
    @Binding var path: NavigationPath
    @StateObject var locationManager = LocationManager()
    @State private var reviews: [ReviewData] = []
    @State private var isLoading = true
    private let reviewRepository = ReviewRepository()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("FoodieLog")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                    
                    ScrollView(showsIndicators: false) {
                        if isLoading {
                            ProgressView("")
                                .padding()
                        } else {
                            VStack(alignment: .leading, spacing: 20) {
                                // 최근 방문한 맛집 섹션
                                Text("최근 등록한 리뷰")
                                    .font(.title3)
                                    .bold()
                                    .padding(.leading, 20)
                                    .padding(.bottom, -20)
                                
                                if reviews.isEmpty {
                                    emptyCardView
                                    
                                } else {
                                    HorizontalScrollView(reviews: $reviews, path: $path)
                                        .frame(height: 300)
                                }
                                
                                // 근처 맛집 섹션
                                LazyVStack(alignment: .leading) {
                                    Text("근처 맛집")
                                        .font(.title3)
                                        .bold()
                                        .padding(.leading, 20)
                                        .padding(.bottom, -20)
                                    
                                    if locationManager.authorizationStatus == .authorizedWhenInUse ||
                                        locationManager.authorizationStatus == .authorizedAlways {
                                        NearByReStaurantView()
                                            .environmentObject(locationManager)
                                    } else {
                                        //                                        Text("위치 권한을 허용해주세요.")
                                        //                                            .padding(.leading, 20)
                                        //                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Floating Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(value: NavigationDestination.rateView) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(ColorSet.accent.color)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .rateView:
                    RateAndSearchRestaurantsView(path: $path)
                case .addPost(let rating, let place):
                    AddPostView(rating: rating, selectedPlace: .constant(place), path: $path)
                }
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("RefreshReviews"), object: nil, queue: .main) { _ in
                    refreshReviews()
                }
                refreshReviews()
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RefreshReviews"), object: nil)
            }
            .onChange(of: path) { _ in
                
                refreshReviews()
            }
            .background(ColorSet.primary.color)
            .navigationBarHidden(true)
        }
    }
    
    private func refreshReviews() {
        locationManager.requestLocationPermission()
        reviews = reviewRepository.fetchLatestFive()
        isLoading = false
    }
    
    private var emptyCardView: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .cornerRadius(20)
                .overlay(
                    Text("최근 등록한 리뷰가 없습니다.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding() // 내부 패딩
                )
        }
        .frame(maxWidth: .infinity, minHeight: 250)
        .padding(.horizontal)
        .padding(.top)
    }
}
