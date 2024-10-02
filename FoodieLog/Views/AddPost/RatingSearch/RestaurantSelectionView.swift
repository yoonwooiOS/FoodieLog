//
//  RestaurantSelectionView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import SwiftUI

struct RestaurantSelectionView: View {
    @Binding var selectedPlace: Place?
    @Binding var isSearchingRestaurant: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let place = selectedPlace {
                selectedPlaceView(place: place)
            } else {
                restaurantRegistrationButton
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
    }
    
    private func selectedPlaceView(place: Place) -> some View {
        Button{
            isSearchingRestaurant = true
        } label: {
            VStack {
                VStack(alignment: .center, spacing: 8) {
                    Text(place.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(place.formattedAddress ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                MapView(selectedPlace: $selectedPlace)
                    .frame(width: 320,height: 100)
                    .cornerRadius(8)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var restaurantRegistrationButton: some View {
        Button {
            isSearchingRestaurant = true
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text("식당 등록")
                    .font(.headline)
                    .foregroundColor(.primary)
                LocationView()
            }
        }
    }
}

