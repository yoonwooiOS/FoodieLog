//
//  DetailView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/26/24.
//

import SwiftUI
import MapKit

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State private var currentIndex: Int = 0
    @State private var showingActionSheet = false
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var reviewData: ReviewData
    @State private var isDeleted = false
    let reviewRepository = ReviewRepository()
    
    init(reviewData: ReviewData, path: Binding<NavigationPath>) {
        self._path = path
        self._reviewData = State(initialValue: reviewData)
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // 이미지 슬라이더
                ZStack(alignment: .bottom) {
                    DetailViewHorizontalScrollView(currentIndex: $currentIndex, review: reviewData)
                        .frame(height: 300)
                    
                    PageControl(numberOfPages: reviewData.imagePaths.count, currentIndex: $currentIndex)
                        .padding(.bottom, 8)
                }
                .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading, spacing: 20) {
                    // 제목
                    VStack(alignment: .leading, spacing: 8) {
                        Text("제목")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(reviewData.title)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // 후기
                    VStack(alignment: .leading, spacing: 8) {
                        Text("후기")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(reviewData.content)
                            .font(.body)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // 식당 정보
                    VStack(alignment: .leading, spacing: 8) {
                        Text(reviewData.restaurantName)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(reviewData.restaurantAddress)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(reviewData.rating.oneDecimalString)
                                .font(.subheadline)
                            Text(formattedDate(reviewData.date))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        DetailMapView(latitude: reviewData.latitude, longitude: reviewData.longitude)
                            .frame(height: 150)
                            .cornerRadius(12)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding()
                .background(ColorSet.primary.color)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.black)
                        .bold()
                        .padding(8)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color.black)
                        .bold()
                        .padding(8)
                }
            }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("리뷰 관리"), buttons: [
                .destructive(Text("삭제")) { showingDeleteAlert = true },
                .cancel(Text("취소"))
            ])
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("리뷰 삭제"),
                message: Text("이 리뷰를 삭제하시겠습니까?"),
                primaryButton: .default(Text("취소")) {
                    showingDeleteAlert = false
                }, secondaryButton: .destructive(Text("삭제")) {
                    deleteReview()
                }
            )
        }
        .onDisappear {
            if isDeleted {
                // HomeView에서 리뷰 갱신을 처리할 수 있도록 설정
                NotificationCenter.default.post(name: NSNotification.Name("RefreshReviews"), object: nil)
            }
        }
    }
    
    private func deleteReview() {
        DispatchQueue.main.async {
            if let review = self.reviewRepository.fetch(by: self.reviewData.id) {
                self.reviewRepository.delete(review)
                self.isDeleted = true
                presentationMode.wrappedValue.dismiss()
                if !path.isEmpty {
                    path.removeLast(path.count)
                }
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
struct DetailMapView: View {
    var latitude: String
    var longitude: String
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
    )
    @State private var locations: [MapLocation] = []
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                    Text("Location")
                        .foregroundColor(.black)
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
        .task {
            setRegion(latitude: latitude, longitude: longitude)
        }
    }
    
    private func setRegion(latitude: String, longitude: String) {
        if let lat = Double(latitude), let lon = Double(longitude) {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
            locations = [MapLocation(coordinate: coordinate)]
        }
    }
}
