//
//  NearBy.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/20/24.
//

import SwiftUI
import CoreLocation

struct NearByReStaurantView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var places: [Place] = []
    @State private var photos: [String: UIImage] = [:]  // placeID를 키로 저장
    private let placeService = PlaceService()
    private let photoService = PhotoService()

    var body: some View {
        VStack {
            if let location = locationManager.location {
//               Text("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//                    .font(.headline) 

                // 맛집 리스트
                List(places, id: \.placeID) { place in
                    HStack {
                        if let image = photos[place.placeID] {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                        } else {
                            Rectangle()  // 로딩 중일 때 사용할 placeholder
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .foregroundColor(.gray)
                                .onAppear {
                                    if let photoRef = place.photos?.first?.photoReference {
                                        fetchPlacePhoto(photoReference: photoRef, for: place.placeID)
                                    }
                                }
                        }
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                            Text(place.vicinity ?? "No Address")
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 8)
                }
            } else {
                Text("위치를 가져오는 중...")
                    .font(.headline)
                    .onAppear {
                        locationManager.requestLocationPermission()
                    }
            }
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                fetchNearbyRestaurants(location: location)
            }
        }
    }
    
    // 음식점 검색
    func fetchNearbyRestaurants(location: CLLocation) {
        placeService.searchNearbyRestaurants(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { results in
            if let results = results {
                DispatchQueue.main.async {
                    self.places = results
                }
            }
        }
    }

    // 사진 가져오기
    func fetchPlacePhoto(photoReference: String, for placeID: String) {
        photoService.fetchPlacePhoto(photoReference: photoReference) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.photos[placeID] = image
                }
            }
        }
    }
}
#Preview {
    NearByReStaurantView()
}
