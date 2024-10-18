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
    @StateObject private var viewModel: DetailViewModel
    @State private var currentIndex: Int = 0
    
    init(reviewData: ReviewData, path: Binding<NavigationPath>) {
        self._path = path
        self._viewModel = StateObject(wrappedValue: DetailViewModel(reviewData: reviewData))
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    DetailViewHorizontalScrollView(currentIndex: $currentIndex, review: viewModel.output.reviewData)
                        .frame(height: 300)
                        .ignoresSafeArea(edges: .top)
                    PageControl(numberOfPages: viewModel.output.reviewData.imagePaths.count, currentIndex: $currentIndex)
                        .padding(.bottom, 8)
                }
                .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading, spacing: 20) {
                    titleSection
                    reviewSection
                    restaurantInfoSection
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
            ToolbarItem(placement: .navigationBarLeading) { backButton }
            ToolbarItem(placement: .navigationBarTrailing) { moreButton }
        }
        .actionSheet(isPresented: .constant(viewModel.output.showingActionSheet)) {
            ActionSheet(title: Text("리뷰 관리"), buttons: [
//                .default(Text("편집")) { viewModel.input.editReviewTapped.send()},
                .destructive(Text("삭제")) { viewModel.input.confirmDeleteTapped.send() },
                .cancel(Text("취소"))
            ])
        }
        .alert(isPresented: .constant(viewModel.output.showingDeleteAlert)) {
            Alert(
                title: Text("리뷰 삭제"),
                message: Text("이 리뷰를 삭제하시겠습니까?"),
                primaryButton: .default(Text("취소")),
                secondaryButton: .destructive(Text("삭제")) {
                    viewModel.input.deleteReviewTapped.send()
                }
            )
        }
        .navigationDestination(isPresented: $viewModel.output.showingEditView, destination: {
            EditView(reviewId: viewModel.output.reviewData.id, path: $path)
        })
        .onAppear { viewModel.input.viewAppeared.send()
            print(viewModel.output.reviewData.id)}
        .onChange(of: viewModel.output.isDeleted) { isDeleted in
            if isDeleted {
                presentationMode.wrappedValue.dismiss()
//                if !path.isEmpty {
//                    path.removeLast(path.count)
//                }
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.black)
                .bold()
                .padding(8)
        }
    }
    
    private var moreButton: some View {
        Button(action: {
            viewModel.input.showActionSheetTapped.send()
        }) {
            Image(systemName: "ellipsis")
                .foregroundColor(Color.black)
                .bold()
                .padding(8)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("제목")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(viewModel.output.reviewData.title)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("후기")
                .font(.headline)
                .foregroundColor(.secondary)
            Text(viewModel.output.reviewData.content)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var restaurantInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(viewModel.output.reviewData.restaurantName)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(viewModel.output.reviewData.category)
                    .foregroundStyle(.gray)
                    .font(.subheadline)
            }
           
            Text(viewModel.output.reviewData.restaurantAddress)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(viewModel.output.reviewData.rating.oneDecimalString)
                    .font(.subheadline)
                Text(formattedDate(viewModel.output.reviewData.date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            DetailMapView(latitude: viewModel.output.reviewData.latitude, longitude: viewModel.output.reviewData.longitude, restaurantName: viewModel.output.reviewData.restaurantName)
                .frame(height: 150)
                .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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

struct DetailMapView: View {
    var latitude: String
    var longitude: String
    var restaurantName: String
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
                    Text(restaurantName)
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
//        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
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

struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
