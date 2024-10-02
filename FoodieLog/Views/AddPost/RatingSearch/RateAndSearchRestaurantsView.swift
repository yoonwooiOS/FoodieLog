//
//  RateAndSearchRestaurantsView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import SwiftUI
import Cosmos
import MapKit


struct RateAndSearchRestaurantsView: View {
    @Binding var path: NavigationPath
    @State private var rating: Double = 0
    @State private var selectedPlace: Place?
    @State private var isSearchingRestaurant: Bool = false
    var body: some View {
        ScrollView {
           
            VStack {
                ColorSet.primary.color
                                    .ignoresSafeArea()
                VStack(spacing: 12) {
                    Text("터치를 통해 별점을 입력해주세요!")
                        .font(.title2)
                        .fontWeight(.bold)
                    ratingSection
                    RestaurantSelectionView(selectedPlace: $selectedPlace, isSearchingRestaurant: $isSearchingRestaurant)
                    Button(action: {
                        path.append(NavigationDestination.addPost(rating: rating, place: selectedPlace))
                    }) {
                        Text("Next")
                            .fontWeight(.semibold)
                            .frame(width: 320)
                            .padding()
                            .background(Color(hex: "#d4a373"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 12)
                    .disabled(rating == 0 || selectedPlace == nil)
                }
            }
            .sheet(isPresented: $isSearchingRestaurant) {
                SearchRestaurantsView(selectedPlace: $selectedPlace, isShowSheet: $isSearchingRestaurant)
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("후기 작성")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var ratingSection: some View {
        VStack {
            Text("\(rating.oneDecimalString)점")
                .font(.headline)
            
            RatingView(rating: $rating, starSize: 35)
                .frame(width: 200, height: 40)
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}
