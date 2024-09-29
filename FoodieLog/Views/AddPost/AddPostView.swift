//
//  AddPostView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/20/24.
//

import SwiftUI
import Cosmos
import MapKit
import PhotosUI

struct BaseBoxView: View {
    @State private var reviewText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("리뷰")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextEditor(text: $reviewText)
                .customStyleEditor(placeholder: "후기 작성해주세요", userInput: $reviewText)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .frame(height: 150)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            
        }
        
    }
}
struct CustomTextFieldView: View {
    @State private var inputText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("제목")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, -6)
            TextField("제목을 입력하세요", text: $inputText)
                .font(.system(size: 18))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .frame(maxHeight: .infinity)
                .frame(height: 60)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
        }
    }
}
struct LocationView: View {
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "map")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.8))
                Text("지도에서 맛집을 검색하고 등록해보세요!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            .frame(width: 360, height: 100)
            .cornerRadius(20)
            .background(Color.gray.opacity(0.1))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
        }
    }
}

struct AddPostView: View {
    @State private var visitDate = Date()
    @State private var isShowingDatePicker = false
    @State private var rating: Double = 0
    @State private var selectedPlace: Place?
    @State private var isShowSheet = false
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isPhotosPickerPresented: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    CustomTextFieldView()
                        .padding(.horizontal)
                    dateSelectionView
                        .padding(.horizontal)
                    BaseBoxView()
                        .padding(.horizontal)
                    restaurantSelectionView
                    photoView
                        .padding(.horizontal)
                    Divider()
                    ratingView
                        .padding(.horizontal)
                    Divider()
                }
                .padding(.top)
            }
            .navigationTitle("후기 등록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    saveButton
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
        .sheet(isPresented: $isShowingDatePicker) {
            NavigationView {
                VStack(spacing: 20) {
                    DatePicker(
                        "날짜 선택",
                        selection: $visitDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .accentColor(.purple)
                    .padding()
                }
                .navigationBarTitle("날짜 선택", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingDatePicker = false
                        } label: {
                            Text("완료")
                                .foregroundStyle(.black)
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            isShowingDatePicker = false
                        } label: {
                            Text("취소")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $isShowSheet) {
            SearchRestaurantsView(selectedPlace: $selectedPlace, isShowSheet: $isShowSheet)
        }
        .sheet(isPresented: $isPhotosPickerPresented) {
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 5, matching: .images) {
                Text("Select Photos")
            }
            .onChange(of: selectedPhotos) { newPhotos in
                loadPhotos(from: newPhotos)
            }
        }
    }
    
    private var photoView: some View {
        VStack(alignment: .leading) {
            Text("사진 등록")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, 2)
            if selectedImages.isEmpty {
                largePhotoPickerButton
            } else {
                HStack(spacing: 10) {
                    smallPhotoPickerButton
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    
                                        .foregroundColor(.red)
                                        .background(Color.white.opacity(0.7))
                                        .clipShape(Circle())
                                        .offset(x: 10, y: -10)
                                    
                                }
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    deleteImage(at: index)
                                }
                            }
                        }
                        .frame(height: 128)
                    }
                }
                .padding(.top, -8)
            }
        }
    }
    private var largePhotoPickerButton: some View {
        PhotosPicker(selection: $selectedPhotos,
                     maxSelectionCount: 5,
                     matching: .images,
                     photoLibrary: .shared()) {
            VStack {
                Image(systemName: "camera")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.8))
                Text("잘 찍은 사진은 5개까지 등록할 수 있어요!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            .frame(width: 360, height: 100)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
        }
                     .onChange(of: selectedPhotos) { newPhotos in
                         loadPhotos(from: newPhotos)
                     }
    }
    
    private var smallPhotoPickerButton: some View {
        PhotosPicker(selection: $selectedPhotos,
                     maxSelectionCount: 5,
                     matching: .images,
                     photoLibrary: .shared()) {
            VStack {
                Image(systemName: "plus")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
            }
            .frame(width: 100, height: 100)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
    private func loadPhotos(from items: [PhotosPickerItem]) {
        selectedImages.removeAll()
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            selectedImages.append(image)
                        }
                    }
                case .failure(let error):
                    print("사진 로드 실패: \(error)")
                }
            }
        }
    }
    private func deleteImage(at index: Int) {
        selectedImages.remove(at: index)
        if index < selectedPhotos.count {
            selectedPhotos.remove(at: index)
        }
    }
    private var dateSelectionView: some View {
        VStack(alignment: .leading) {
            Text("방문 일자")
                .font(.headline)
                .foregroundColor(.primary)
            
            Button(action: {
                isShowingDatePicker = true
            }) {
                HStack {
                    Text(formattedDate(visitDate))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .frame(height: 52)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                .cornerRadius(8)
            }
        }
    }
    
    private var ratingView: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                RatingView(rating: $rating)
                    .frame(width: 200, height: 40)
                Spacer()
            }
            Text("\(rating.formatted())점")
                .foregroundStyle(.gray)
                .padding(.top, 8)
        }
    }
    
    private var restaurantSelectionView: some View {
        VStack {
            if selectedPlace == nil {
                VStack(alignment: .leading, spacing: 16) {
                    Text("식당 등록")
                        .font(.headline)
                        .padding(.bottom, -6)
                    Button {
                        self.isShowSheet.toggle()
                    } label: {
                        LocationView()
                        
                    }
                }
            } else {
                VStack(alignment: .leading) {
                    Text(selectedPlace?.name ?? "")
                        .font(.headline)
                        .bold()
                    Text(selectedPlace?.formattedAddress ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Button {
                        self.isShowSheet.toggle()
                    } label: {
                        MapView(selectedPlace: $selectedPlace)
                            .frame(width: 360, height: 100)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var saveButton: some View {
        Button {
            print("저장")
        } label: {
            Text("저장")
                .foregroundStyle(.black)
        }
    }
}
