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
    @State private var currentIndex: Int = 0
    var review: Review
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 이미지 슬라이더
                ZStack(alignment: .bottom) {
                    HorizontalScrollViews(currentIndex: $currentIndex, review: review)
                        .frame(height: 300)
                    
                    PageControl(numberOfPages: review.imagePaths.count, currentIndex: $currentIndex)
                        .padding(.bottom, 8)
                }
                .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading, spacing: 20) {
                    // 제목
                    VStack(alignment: .leading, spacing: 8) {
                        Text("제목")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(review.title)
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
                        Text(review.content)
                            .font(.body)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // 식당 정보
                    VStack(alignment: .leading, spacing: 8) {
                        Text(review.restaurantName)
                            .font(.title3)
                            .fontWeight(.bold)
                        Text(review.restaurantAddress)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(review.rating.oneDecimalString)
                                .font(.subheadline)
                            Text(formattedDate(review.date))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        DetailMapView(latitude: review.latitude, longitude: review.longitude)
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
        .edgesIgnoringSafeArea(.top)
        .background(ColorSet.primary.color.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setTransparentBackButton()
        }
        .onDisappear {
            resetNavigationBar()
        }
    }
    
    private func setTransparentBackButton() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        // Back 버튼의 텍스트를 투명하게 설정
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.clear]
        appearance.backButtonAppearance = backButtonAppearance
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // 기본 내비게이션 바 스타일로 복원
    private func resetNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
extension UINavigationBar {
    static func changeAppearance(clear: Bool) {
        let appearance = UINavigationBarAppearance()
        
        if clear {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.configureWithDefaultBackground()
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
struct HorizontalScrollViews: View {
    @Binding var currentIndex: Int
    @State private var reviewImages: [Image] = []
    @State private var offset: CGFloat = 0
    @GestureState private var translation: CGFloat = 0
    var review: Review
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    ForEach(reviewImages.indices, id: \.self) { index in
                        reviewImages[index]
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: 300)
                            .clipped()
                    }
                }
                .offset(x: -CGFloat(currentIndex) * geometry.size.width + offset + translation)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: offset)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: translation)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            state = value.translation.width
                        }
                        .onEnded { value in
                            let threshold: CGFloat = geometry.size.width * 0.1
                            if value.translation.width < -threshold {
                                currentIndex = min(currentIndex + 1, reviewImages.count - 1)
                            } else if value.translation.width > threshold {
                                currentIndex = max(currentIndex - 1, 0)
                            }
                            offset = 0
                        }
                )
                
                PageControl(numberOfPages: reviewImages.count, currentIndex: $currentIndex)
                    .padding(.top, 8)
            }
        }
        //        .frame(height: 300)
        .clipped()
        .task {
            loadImages()
        }
    }
    
    private func loadImages() {
        reviewImages = review.imagePaths.compactMap { imagePath in
            if let uiImage = ImageManager.shared.loadImageFromDisk(imageName: imagePath) {
                return Image(uiImage: uiImage)
            }
            return nil
        }
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
