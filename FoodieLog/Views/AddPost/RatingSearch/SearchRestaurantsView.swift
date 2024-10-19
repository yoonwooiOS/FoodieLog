//
//  SearchRestaurantsView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/24/24.
//

import SwiftUI


struct SearchRestaurantsView: View {
    @State var searchText = ""
    @State var places: [Place] = []
    @Binding var selectedPlace: Place?
    @Binding var isShowSheet: Bool
    private var networkManager = NetworkManager()
    // 사용자 정의 이니셜라이저
    init(selectedPlace: Binding<Place?>, isShowSheet: Binding<Bool>) {
        self._selectedPlace = selectedPlace
        self._isShowSheet = isShowSheet
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorSet.primary.color
                    .ignoresSafeArea()
                VStack {
                    if places.isEmpty {
                        Text("검색 결과가 없습니다.")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding()
                    } else {
                        List(places) { place in
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(place.name)
                                        Text(place.formattedAddress ?? "주소 정보 없음")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Button {
                                        selectedPlace = place
                                        isShowSheet = false
                                    } label: {
                                        Text("선택")
                                    }
                                }
                            }
                        }
                        .padding(.top, 0.5)
                    }
                }
                .searchable(text: $searchText, prompt: "음식점을 검색하세요")
                .onSubmit(of: .search) {
                    // Google Places Text Search API 호출
                    networkManager.searchGooglePlaces(for: searchText) { result in
                        if let resultPlaces = result {
                            places = resultPlaces
                        } else {
                            places = []
                        }
                    }
                }
                .navigationTitle("음식점 검색")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isShowSheet = false
                        } label: {
                            Text("취소")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }

        }
    }
}
