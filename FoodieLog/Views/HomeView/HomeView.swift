//
//  HomeView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI


struct HomeView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = HomeViewModel()
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
                        if viewModel.output.isLoading {
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
                                
                                if viewModel.output.reviews.isEmpty {
                                    emptyCardView
                                } else {
                                    HorizontalScrollView(reviews: .constant(viewModel.output.reviews), path: $path)
                                        .frame(height: 300)
                                }
                                
                                // 근처 맛집 섹션
                                LazyVStack(alignment: .leading) {
                                    Text("근처 맛집")
                                        .font(.title3)
                                        .bold()
                                        .padding(.leading, 20)
                                        .padding(.bottom, -20)
                                    
                                    if viewModel.output.locationAuthorizationStatus == .authorizedWhenInUse ||
                                        viewModel.output.locationAuthorizationStatus == .authorizedAlways {
                                        NearByReStaurantView()
                                            .environmentObject(viewModel.locationManager)
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
                viewModel.action(.viewAppeared)
            }
            .onChange(of: path) { _ in
                viewModel.action(.refreshRequested)
            }
            .background(ColorSet.primary.color)
            .navigationBarHidden(true)
        }
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
                        .padding()
                )
        }
        .frame(maxWidth: .infinity, minHeight: 250)
        .padding(.horizontal)
        .padding(.top)
    }
}
