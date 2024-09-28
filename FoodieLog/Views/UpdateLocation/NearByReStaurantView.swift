//
//  NearBy.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/20/24.
//

import SwiftUI
import CoreLocation

struct NearByReStaurantView: View {
    @EnvironmentObject private var locationManager: LocationManager
    @State private var places: [Place] = []
    @State private var photos: [String: UIImage] = [:]
    private var networkManager = NetworkManager.shared
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if places.isEmpty {
                    VStack(alignment: .center) {
                        ProgressView("근처 맛집을 조회하고 있습니다. 잠시만 기다려주세요!")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .multilineTextAlignment(.center)
                            .padding()
                            .padding(.top, 72)
                            .onAppear {
                                fetchNearbyRestaurants(location: location)
                            }
                    }
                } else {
                    VStack(alignment: .leading) {
                        ForEach(places, id: \.placeID) { place in
                                HStack {
                                    if let image = photos[place.placeID] {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                    } else {
                                        Rectangle()
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
                                    .foregroundStyle(.black)
                                    Spacer()
                                    Button(action: {
                                        openAppleMap(place: place)
                                    }) {
                                        Image(systemName: "map")
                                            .foregroundColor(.black)
                                    }
                                    
                                    .padding(.vertical, 8)
                                }
                            
                            .padding(.vertical, 8)
                        }
                    }
                    .padding()
                }
            } else {
                Text("")
                    .font(.headline)
            }
        }
    }
    
    func fetchNearbyRestaurants(location: CLLocation) {
        networkManager.searchGoogleNearbyRestaurants(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { results in
            if let results = results {
                DispatchQueue.main.async {
                    self.places = results
                    for place in results {
                        if let photoRef = place.photos?.first?.photoReference {
                            fetchPlacePhoto(photoReference: photoRef, for: place.placeID)
                        }
                    }
                }
            }
        }
    }
    
    func fetchPlacePhoto(photoReference: String, for placeID: String) {
        networkManager.fetchGooglePlacePhoto(photoReference: photoReference) { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.photos[placeID] = image
                }
            }
        }
    }
    func openAppleMap(place: Place) {
           let latitude = place.geometry.location.lat
           let longitude = place.geometry.location.lng
           let placeName = place.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Unknown" // 특수문자 Encoding

           // Apple 지도 URL Scheme 생성
           let appleMapURL = URL(string: "http://maps.apple.com/?q=\(placeName)&ll=\(latitude),\(longitude)")!
           // URL 열기 시도
           if UIApplication.shared.canOpenURL(appleMapURL) {
               UIApplication.shared.open(appleMapURL, options: [:], completionHandler: nil)
           }
       }
}
#Preview {
    NearByReStaurantView()
}
