//
//  DetailViewModel.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/6/24.
//

import SwiftUI
import Combine

final class DetailViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input: Input
    @Published var output: Output
    
    private let reviewRepository: ReviewRepository
    
    init(reviewData: ReviewData, reviewRepository: ReviewRepository = ReviewRepository()) {
        self.reviewRepository = reviewRepository
        self.input = Input()
        self.output = Output(reviewData: reviewData)
        transform()
    }
    
    struct Input {
        let viewAppeared = PassthroughSubject<Void, Never>()
        let deleteReviewTapped = PassthroughSubject<Void, Never>()
        let showActionSheetTapped = PassthroughSubject<Void, Never>()
        let confirmDeleteTapped = PassthroughSubject<Void, Never>()
        let editReviewTapped = PassthroughSubject<Void, Never>()
    }
    struct Output {
        var reviewData: ReviewData
        var showingActionSheet = false
        var showingDeleteAlert = false
        var isDeleted = false
        var showingEditView = false
    }
    func transform() {
        print(#function, "DetailViewViewModel")
        input.showActionSheetTapped
            .sink { [weak self] in
                self?.output.showingActionSheet = true
            }
            .store(in: &cancellables)
        
        input.confirmDeleteTapped
            .sink { [weak self] in
                self?.output.showingDeleteAlert = true
            }
            .store(in: &cancellables)
        
        input.deleteReviewTapped
            .sink { [weak self] in
                self?.deleteReview()
            }
            .store(in: &cancellables)
        
        input.editReviewTapped
            .sink { [weak self] in
                self?.output.showingEditView = true
                print("editRevieTapped")
            }
            .store(in: &cancellables)
    }
    private func deleteReview() {
        if let review = self.reviewRepository.fetch(by: self.output.reviewData.id) {
            self.reviewRepository.delete(review)
            self.output.isDeleted = true
        }
    }
}
