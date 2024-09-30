//
//  MapViewExample.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/26/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var selectedPlace: Place?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // 초기화: 서울역
        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: selectedPlace != nil ? [selectedPlace!] : []) { place in
            //map pin
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.geometry.location.lat, longitude: place.geometry.location.lng)) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                    Text(place.name)
                        .foregroundStyle(.black)
                        .font(.caption)
                }
            }
        }
        .cornerRadius(20)
        .background(Color.gray.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if let selectedPlace = selectedPlace {
                setRegion(for: selectedPlace)
            }
        }
        .onChange(of: selectedPlace) { newPlace in
            if let newPlace = newPlace {
                setRegion(for: newPlace)
            }
        }
    }
    private func setRegion(for place: Place) {
        let latitude = place.geometry.location.lat
        let longitude = place.geometry.location.lng

        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }
}
//#Preview {
//    MapsView()
//}
//
