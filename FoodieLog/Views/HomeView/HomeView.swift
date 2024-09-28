//
//  HomeView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("최근 방문한 맛집")
                        .font(.title2)
                        .bold()
                        .padding(.leading, 20)
                        .padding(.bottom, -20)
                    NavigationLink {
                        DetailView()
                    } label: {
                        HorizontalScrollView()
                    }
                    .buttonStyle(.plain)
                    LazyVStack(alignment: .leading) {
                        Text("근처 맛집")
                            .font(.title2)
                            .bold()
                            .padding(.leading, 20)
                            .padding(.bottom, -20)
                        if locationManager.authorizationStatus == .authorizedWhenInUse ||
                            locationManager.authorizationStatus == .authorizedAlways {
                            //                            let _ = print("Authorization Status: \(locationManager.authorizationStatus.rawValue)")
                            //                            let _ = print(locationManager.location?.coordinate.latitude ?? 0)
                            //                            let _ = print(locationManager.location?.coordinate.longitude ?? 0)
                            NearByReStaurantView()
                                .environmentObject(locationManager)
                        } else {
                            Text("")
                                .padding(.leading, 20)
                                .onAppear {
                                    locationManager.requestLocationPermission()
                                }
                        }
                    }
                }
            }
            .navigationTitle("맛집 Log")
        }
    }
}

#Preview {
    HomeView()
}
