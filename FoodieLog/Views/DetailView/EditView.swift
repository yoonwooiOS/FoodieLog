//
//  EditReviewView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/3/24.
//

import SwiftUI
import RealmSwift
import PhotosUI

struct EditView: View {
    @StateObject private var viewModel: EditViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    @State private var currentIndex: Int = 0
    @State private var isShowingDatePicker = false
    @State private var selectedItems: [PhotosPickerItem] = []
    
    init(reviewId: ObjectId, path: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: EditViewModel(reviewId: reviewId))
        self._path = path
    }
    
    var body: some View {
        ZStack {
            ColorSet.primary.color.ignoresSafeArea()
            ScrollView {
                Divider()
                VStack(spacing: 0) {
                    placeInfoView
                        .padding(.bottom, 4)
                    mapView
                    VStack(spacing: 20) {
                        titleSection
                            .padding(.top, 16)
                        dateSelectionView
                        contentSection
                        photoView
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("리뷰 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { backButton }
            ToolbarItem(placement: .navigationBarTrailing) { saveButton }
        }
        .alert(item: alertBinding) { alertItem in
            Alert(title: Text("알림"), message: Text(alertItem.message), dismissButton: .default(Text("확인")) {
                if viewModel.output.shouldDismiss {
                    path.removeLast(path.count)
                }
            })
        }
        .onChange(of: viewModel.output.shouldDismiss) { shouldDismiss in
                    if shouldDismiss {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
    }
        
    private var placeInfoView: some View {
        HStack {
            Text(viewModel.output.selectedPlace?.name ?? "")
                .font(.headline)
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundColor(.yellow)
            Text(viewModel.output.rating.oneDecimalString)
                .font(.caption)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    private var mapView: some View {
        MapView(selectedPlace: .constant(viewModel.output.selectedPlace))
            .frame(height: 80)
            .cornerRadius(8)
            .padding(.horizontal)
    }
    
    private var titleSection: some View {
        CustomTextFieldView(title: Binding(
            get: { viewModel.output.title },
            set: { viewModel.input.updateTitle.send($0) }
        ))
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
                    Text(formattedDate(viewModel.output.visitDate))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(height: 52)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }
        }
        .sheet(isPresented: $isShowingDatePicker) {
            NavigationView {
                DatePicker(
                    "날짜 선택",
                    selection: Binding(
                        get: { viewModel.output.visitDate },
                        set: { viewModel.input.updateVisitDate.send($0) }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .accentColor(Color(hex: "f58402"))
                .environment(\.locale, Locale(identifier: String(Locale.preferredLanguages[0]))) //설정 언어 첫번째
                .padding()
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
    }
    
    private var contentSection: some View {
        ReviewContentView(content: Binding(
            get: { viewModel.output.content },
            set: { viewModel.input.updateContent.send($0) }
        ))
    }
    
    private var photoView: some View {
            VStack(alignment: .leading) {
                Text("사진 등록 \(viewModel.output.selectedImages.count)/5")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.bottom, 2)
                if viewModel.output.selectedImages.isEmpty {
                    largePhotoPickerButton
                } else {
                    HStack(spacing: 10) {
                        smallPhotoPickerButton
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Array(viewModel.output.selectedImages.enumerated()), id: \.element) { index, image in
                                    imageView(for: index, image: image)
                                }
                            }
                            .frame(height: 100)
                        }
                    }
                }
            }
        }
    
    private var largePhotoPickerButton: some View {
        PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
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
        }
        .onChange(of: selectedItems) { newItems in
            viewModel.input.updateSelectedPhotosItems.send(newItems)
        }
    }
    
    private var smallPhotoPickerButton: some View {
        PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
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
        .onChange(of: selectedItems) { newItems in
            viewModel.input.updateSelectedPhotosItems.send(newItems)
        }
    }
    
    private func imageView(for index: Int, image: UIImage) -> some View {
           Image(uiImage: image)
               .resizable()
               .aspectRatio(contentMode: .fill)
               .frame(width: 100, height: 100)
               .clipShape(RoundedRectangle(cornerRadius: 10))
               .overlay(
                   Button(action: {
                       viewModel.input.deletePhoto.send(index)
                   }) {
                       Image(systemName: "xmark.circle.fill")
                           .foregroundColor(.red)
                           .background(Color.white)
                           .clipShape(Circle())
                   }
                   .padding(4),
                   alignment: .topTrailing
               )
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
    
    private var saveButton: some View {
            Button(action: {
                viewModel.input.saveReview.send()
            }) {
                Text("저장")
                    .foregroundColor(.black)
            }
        }
    
    private var alertBinding: Binding<AlertItem?> {
        Binding<AlertItem?>(
            get: { viewModel.output.alertMessage.map { AlertItem(message: $0) } },
            set: { _ in }
        )
    }
}

struct AlertItem: Identifiable {
    let id = UUID()
    let message: String
}
