//
//  HomeView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var locationManager = LocationManager()
    @State var aroundRestaurants = [KakaoPlace]()
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(alignment: .leading, spacing: 20) {
                        // 상단 제목과 설명
                        Text("최근 방문한 맛집")
                            .font(.title2)
                            .bold()
                            .padding(.leading, 20)
                        
                        // 수평 스크롤 뷰 (최근 방문한 맛집 리스트)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<5) { _ in
                                    FoodCardView()
                                        .frame(width: 350, height: 280)  // 명시적인 크기 설정
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        VStack(alignment: .leading) {
                            Text("근처 맛집")
                                .font(.title2)
                                .bold()
                                .padding([.leading, .bottom], 20)
                            ForEach(aroundRestaurants) { data in
                                HStack {
                                    Text(data.place_name)
                                        .font(.title)
                                    Text("\(data.distance)m")
                                }
                                .padding(.leading, 20)
                            }
                        }
                    }
                }
            }
            .navigationTitle("맛집 Log")
        }
        .task {
            locationManager.startUpdatingLocation()
            print("HomeView reload")
            if let location = locationManager.location {
                print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                DispatchQueue.main.async {
                    NetworkCall.shared.fetchAroundRestaurants(query: KakaoAPIQuery(query: "근처 맛집", latitude: location.coordinate.latitude  , longitude: location.coordinate.longitude)) { result in
                        aroundRestaurants = result.documents
                        dump(result)
                    }
                }
            } else {
                print("위치를 가져오지 못했습니다.")
            }
        }
    }
}

#Preview {
    HomeView()
}
