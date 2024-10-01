//
//  HomeView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI


struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    @State private var reviews: [Review] = []
    @State private var isLoading = true
    private let reviewRepository = ReviewRepository()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    if isLoading {
                        ProgressView("")
                            .padding()
                    } else {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("최근 방문한 맛집")
                                .font(.title2)
                                .bold()
                                .padding(.leading, 20)
                                .padding(.bottom, -20)
                            
                            HorizontalScrollView(reviews: $reviews)
                                .frame(height: 300)
                            
                            LazyVStack(alignment: .leading) {
                                Text("근처 맛집")
                                    .font(.title2)
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
                //FloatingButton
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink {
                            AddPostView()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .task {
                locationManager.requestLocationPermission()
                reviews = reviewRepository.fetchLatestFive()
                isLoading = false // 데이터가 로드된 후 로딩 상태를 해제
            }
            .navigationTitle("맛집 Log")
        }
    }
}

#Preview {
    HomeView()
}
