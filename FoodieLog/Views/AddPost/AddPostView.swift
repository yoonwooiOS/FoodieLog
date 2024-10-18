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

struct AddPostView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var visitDate = Date()
    @State private var isShowingDatePicker = false
    @State var rating: Double
    @Binding var selectedPlace: Place?
    @State private var isShowSheet = false
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var isPhotosPickerPresented: Bool = false
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    private let reviewRepository = ReviewRepository()
    private let imageManager = ImageManager.shared
    @State private var selectedCategory: String = ""
    let foodCategories = ["한식", "중식", "양식", "일식", "패스트푸드", "분식", "간편식", "세계음식", "기타"]
    @Binding var path: NavigationPath
    private var isSaveButtonEnabled: Bool {
        !title.isEmpty && !selectedImages.isEmpty && selectedPlace != nil
    }
    
    @State private var shouldDismiss = false
    init(rating: Double, selectedPlace: Binding<Place?>, path: Binding<NavigationPath>) {
        self._rating = State(initialValue: rating)
        self._selectedPlace = selectedPlace
        self._path = path
        setupNavigationBarAppearance()
    }
    var body: some View {
        ZStack {
            ColorSet.primary.color.ignoresSafeArea()
            ScrollView {
                HStack {
                    Text(selectedPlace?.name ?? "")
                        .font(.headline)
                    
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding(.leading, -4)
                    Text(rating.oneDecimalString)
                        .font(.caption)
                        .padding(.leading, -6)
                    Spacer()
                    
                }
                .padding(.horizontal)
                .padding(.top, 16)
                VStack {
                    MapView(selectedPlace: $selectedPlace)
                        .frame(width: 360, height: 80)
                        .cornerRadius(8)
                        .padding(.leading, 0)
                    Spacer()
                }
                .padding(.horizontal)
                VStack(spacing: 20) {
                    CustomTextFieldView(title: $title)
                        .padding(.horizontal)
                    
                    categorySelectionView
                        .padding(.horizontal)
                    
                    dateSelectionView
                        .padding(.horizontal)
                    ReviewContentView(content: $content)
                        .padding(.horizontal)
                    photoView
                        .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("후기 등록")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.black)
                        //                            .foregroundColor(Color(hex: "B5E5CF"))
                            .padding(8)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("후기 등록")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .toolbarBackground(ColorSet.primary.color, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onTapGesture {
                hideKeyboard()
            }
            .sheet(isPresented: $isShowingDatePicker) {
                NavigationView {
                    ZStack {
                        ColorSet.primary.color.ignoresSafeArea()
                        VStack(spacing: 20) {
                            DatePicker(
                                "날짜 선택",
                                selection: $visitDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .accentColor(Color(hex: "f58402"))
                            .environment(\.locale, Locale(identifier: String(Locale.preferredLanguages[0]))) //설정 언어 첫번째
                            .padding()
                            
                        }
                    }
                    .navigationBarTitle("날짜 선택", displayMode: .inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isShowingDatePicker = false
                            } label: {
                                Text("완료")
                                    .foregroundStyle(.black)
                                    .bold()
                            }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                isShowingDatePicker = false
                            } label: {
                                Text("취소")
                                    .foregroundStyle(.red)
                                    .bold()
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("확인")) {
                        if alertMessage == "리뷰가 성공적으로 저장되었습니다." {
                            path.removeLast(path.count)
                        }
                    }
                )
            }
            
        }
    }
    
    private var photoView: some View {
        VStack(alignment: .leading) {
            Text("사진 등록 \(selectedImages.count)/5")
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
//            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
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
                     .onChange(of: selectedPhotos) { newPhotos in
                         loadPhotos(from: newPhotos)
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
                .frame(height: 52)
                .cornerRadius(8)
                .background(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
                
            }
        }
    }
    private var categorySelectionView: some View {
           VStack(alignment: .leading, spacing: 10) {
               Text("카테고리")
                   .font(.headline)
                   .foregroundColor(.primary)
               
               LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                   ForEach(foodCategories, id: \.self) { category in
                       Button(action: {
                           selectedCategory = (selectedCategory == category) ? "" : category
                           print(category)
                       }) {
                           Text(category)
                               .font(.system(size: 14))
                               .padding(.vertical, 8)
                               .padding(.horizontal, 12)
                               .frame(minWidth: 0, maxWidth: .infinity)
                               .background(selectedCategory == category ? Color.yellow.opacity(0.3) : Color.white)
                               .foregroundColor(.black)
                               .cornerRadius(20)
                               .overlay(
                                   RoundedRectangle(cornerRadius: 20)
                                       .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                               )
                       }
                   }
               }
           }
       }
    private var saveButton: some View {
        Button {
            saveReviewToRealm()
            shouldDismiss = true
        } label: {
            Text("저장")
                .foregroundColor(isSaveButtonEnabled ? .black : .gray)
        }
        .disabled(!isSaveButtonEnabled)
    }
    private func loadPhotos(from items: [PhotosPickerItem]) {
        selectedImages.removeAll()
        selectedPhotos.removeAll()
        for item in items {
            item.loadTransferable(type: Data.self) { result in //MARK: 트러블 슈팅 문제
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            if self.selectedImages.count < 5 {
                                self.selectedImages.append(image)
                            }
                        }
                    }
                case .failure(let error):
                    print("사진 로드 실패: \(error)")
                }
            }
        }
    }
    
    
    
    private func saveReviewToRealm() {
        guard let selectedPlace = selectedPlace else {
            alertMessage = "식당 정보가 필요합니다."
            showAlert = true
            return
        }
        
        let review = Review()
        review.title = title
        review.content = content
        review.rating = rating
        review.date = visitDate
        review.restaurantName = selectedPlace.name
        review.restaurantAddress = selectedPlace.formattedAddress ?? ""
        review.latitude = String(selectedPlace.geometry.location.lat)
        review.longitude = String(selectedPlace.geometry.location.lng)
        review.category = selectedCategory
        
        for (index, image) in selectedImages.enumerated() {
            if let imageName = imageManager.saveImageToDisk(image: image, imageName: "review_image_\(index)_\(review.id.stringValue)") {
                review.imagePaths.append(imageName)
            }
        }
        reviewRepository.add(review)
        alertMessage = "리뷰가 성공적으로 저장되었습니다."
        showAlert = true
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(ColorSet.primary.color)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

struct ReviewContentView: View {
    @Binding var content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("리뷰")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextEditor(text: $content)
                .customStyleEditor(placeholder: "후기 작성해주세요", userInput: $content)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .frame(height: 150)
//                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
            
        }
        
    }
}
struct CustomTextFieldView: View {
    @Binding  var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("제목")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.bottom, -6)
            TextField("제목을 입력하세요", text: $title)
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
//                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
        }
    }
}
