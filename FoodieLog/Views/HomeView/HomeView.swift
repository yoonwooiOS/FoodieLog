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
    @State private var reviews: [Review] = []
    @State private var isLoading = true
    private let reviewRepository = ReviewRepository()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                ColorSet.primary.color
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("FoodieLog")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                    
                    ScrollView {
                        if isLoading {
                            ProgressView("")
                                .padding()
                        } else {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("최근 방문한 맛집")
                                    .font(.title3)
                                    .bold()
                                    .padding(.leading, 20)
                                    .padding(.bottom, -20)
                                
                                HorizontalScrollView(reviews: $reviews)
                                    .frame(height: 300)
                                
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
                                        Text("")
                                            .padding(.leading, 20)
                                    }
                                }
                            }
                        }
                    }
                }
                
                //FloatingButton
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(value: NavigationDestination.rateView) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.init(hex: "#d4a373"))
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
            .task {
                locationManager.requestLocationPermission()
                reviews = reviewRepository.fetchLatestFive()
                isLoading = false
            }
            .navigationBarHidden(true)
        }
    }
}
