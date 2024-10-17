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
        ZStack {
            ColorSet.primary.color.ignoresSafeArea()
            VStack(spacing: 0) {
                Divider()
                VStack(spacing: 12) {
                    
                    Text("터치를 통해 별점을 입력해주세요!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    // 별점 입력 섹션
                    ratingSection
                        .padding(.bottom, 20)
                    
                    // 식당 선택 섹션
                    RestaurantSelectionView(selectedPlace: $selectedPlace, isSearchingRestaurant: $isSearchingRestaurant)
                        .padding(.bottom, 20)
                    
                    // 다음 버튼
                    Button(action: {
                        path.append(NavigationDestination.addPost(rating: rating, place: selectedPlace))
                    }) {
                        Text("다음")
                            .fontWeight(.semibold)
                            .frame(width: 320)
                            .padding()
                            .background(rating == 0 || selectedPlace == nil ? ColorSet.accent.color.opacity(0.5) : ColorSet.accent.color)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 12)
                    .disabled(rating == 0 || selectedPlace == nil)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
                .background(ColorSet.primary.color.ignoresSafeArea())
                .sheet(isPresented: $isSearchingRestaurant) {
                    SearchRestaurantsView(selectedPlace: $selectedPlace, isShowSheet: $isSearchingRestaurant)
                }
                .toolbar(.hidden, for: .tabBar)
                .navigationTitle("후기 작성")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .onAppear {
                    setupNavigationBarAppearance()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            path.removeLast()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .padding(8)
                            
                        }
                    }
                }
            }
        }
    }
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    private var ratingSection: some View {
        VStack {
            Text("\(rating.oneDecimalString)점")
                .font(.headline)
            
            RatingView(rating: $rating, starSize: 35, isInteractive: true)
                .frame(width: 200, height: 40)
        }
        .padding(.horizontal)
    }
}
