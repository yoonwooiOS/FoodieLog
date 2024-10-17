//
//  EditViewModel.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/7/24.
//

import SwiftUI
import RealmSwift
import PhotosUI
import Combine


class EditViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input: Input
    @Published var output: Output
    
    private let reviewRepository: ReviewRepository
    private let imageManager: ImageManager
    
    init(reviewId: ObjectId, reviewRepository: ReviewRepository = ReviewRepository(), imageManager: ImageManager = .shared) {
        self.reviewRepository = reviewRepository
        self.imageManager = imageManager
        self.input = Input()
        self.output = Output()
        
        loadReview(id: reviewId)
        transform()
    }
    
    struct Input {
        let saveReview = PassthroughSubject<Void, Never>()
        let updateTitle = PassthroughSubject<String, Never>()
        let updateContent = PassthroughSubject<String, Never>()
        let updateRating = PassthroughSubject<Double, Never>()
        let updateVisitDate = PassthroughSubject<Date, Never>()
        let updateSelectedPhotos = PassthroughSubject<[UIImage], Never>()
        let updateSelectedPhotosItems = PassthroughSubject<[PhotosPickerItem], Never>()
        let deletePhoto = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var title: String = ""
        var content: String = ""
        var rating: Double = 0.0
        var visitDate: Date = Date()
        var selectedPlace: Place?
        var selectedImages: [UIImage] = []
        var alertMessage: String?
        var shouldDismiss: Bool = false
        var reviewId: ObjectId?
    }
    
    func transform() {
        input.saveReview
            .sink { [weak self] in self?.saveReview() }
            .store(in: &cancellables)
        
        input.updateTitle
            .assign(to: \.output.title, on: self)
            .store(in: &cancellables)
        
        input.updateContent
            .assign(to: \.output.content, on: self)
            .store(in: &cancellables)
        
        input.updateRating
            .assign(to: \.output.rating, on: self)
            .store(in: &cancellables)
        
        input.updateVisitDate
            .assign(to: \.output.visitDate, on: self)
            .store(in: &cancellables)
        
        input.updateSelectedPhotos
            .assign(to: \.output.selectedImages, on: self)
            .store(in: &cancellables)
        
        input.updateSelectedPhotosItems
            .sink { [weak self] items in
                self?.loadPhotos(from: items)
            }
            .store(in: &cancellables)
        
        input.deletePhoto
            .sink { [weak self] index in
                self?.deletePhoto(at: index)
            }
            .store(in: &cancellables)
    }
    
    private func loadReview(id: ObjectId) {
        guard let review = reviewRepository.fetch(by: id) else {
            output.alertMessage = "리뷰를 찾을 수 없습니다."
            return
        }
        
        output.title = review.title
        output.content = review.content
        output.rating = review.rating
        output.visitDate = review.date
        output.selectedPlace = Place(name: review.restaurantName, vicinity: review.restaurantAddress, placeID: "", formattedAddress: review.restaurantAddress, photos: nil, geometry: Geometry(location: Location(lat: Double(review.latitude) ?? 0, lng: Double(review.longitude) ?? 0)))
        output.selectedImages = imageManager.loadImagesFromDisk(imageNames: Array(review.imagePaths))
        output.reviewId = review.id
    }
    
    private func loadPhotos(from items: [PhotosPickerItem]) {
        for item in items {
            item.loadTransferable(type: Data.self) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let data = data, let image = UIImage(data: data) {
                            self?.output.selectedImages.append(image)
                        }
                    case .failure(let error):
                        print("Failed to load photo: \(error)")
                    }
                }
            }
        }
    }
    
    private func deletePhoto(at index: Int) {
        guard index < output.selectedImages.count else { return }
        output.selectedImages.remove(at: index)
    }
    
    private func saveReview() {
        guard let reviewId = output.reviewId,
              let review = reviewRepository.fetch(by: reviewId) else {
            output.alertMessage = "리뷰를 저장할 수 없습니다."
            return
        }
        
        let updatedReview = Review()
        updatedReview.title = output.title
        updatedReview.content = output.content
        updatedReview.rating = output.rating
        updatedReview.date = output.visitDate
        updatedReview.restaurantName = review.restaurantName
        updatedReview.restaurantAddress = review.restaurantAddress
        updatedReview.latitude = review.latitude
        updatedReview.longitude = review.longitude
        
        // Update images
        for (index, image) in output.selectedImages.enumerated() {
            if let imageName = imageManager.saveImageToDisk(image: image, imageName: "review_image_\(index)_\(review.id.stringValue)") {
                updatedReview.imagePaths.append(imageName)
            }
        }
        
        reviewRepository.update(review, with: updatedReview)
        output.alertMessage = "리뷰가 성공적으로 수정되었습니다."
        output.shouldDismiss = true
        DispatchQueue.main.async {
                   self.output.shouldDismiss = true
               }
    }
}
