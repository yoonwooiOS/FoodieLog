//
//  UserPostViewModel.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/6/24.
//

import Foundation
import Combine

final class UserPostViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    private let reviewRepository: ReviewRepository
    
    init(reviewRepository: ReviewRepository = ReviewRepository()) {
        self.reviewRepository = reviewRepository
        transform()
    }
}

extension UserPostViewModel {
    struct Input {
        let viewAppeared = PassthroughSubject<Void, Never>()
        let refreshRequested = PassthroughSubject<Void, Never>()
        let sortRequested = PassthroughSubject<SortOption, Never>()
    }
    
    struct Output {
        var reviews: [ReviewData] = []
        var isLoading = true
    }
    
    func transform() {
        input.viewAppeared
            .merge(with: input.refreshRequested)
            .sink { [weak self] _ in
                self?.refreshReviews()
            }
            .store(in: &cancellables)
        
        input.sortRequested
            .sink { [weak self] sortOption in
                self?.sortReviews(by: sortOption)
            }
            .store(in: &cancellables)
    }
    
    private func refreshReviews() {
        output.isLoading = true
        DispatchQueue.main.async {
            self.output.reviews = self.reviewRepository.fetchAll().map { ReviewData(from: $0) }
            self.sortReviews(by: .latest) // 기본 정렬은 최신순
            self.output.isLoading = false
        }
    }
    
    private func sortReviews(by option: SortOption) {
        output.isLoading = true
        DispatchQueue.main.async {
            switch option {
            case .latest:
                self.output.reviews.sort { $0.date > $1.date }
            case .highestRated:
                self.output.reviews.sort { $0.rating > $1.rating }
            case .lowestRated:
                self.output.reviews.sort { $0.rating < $1.rating }
            }
            self.output.isLoading = false
        }
    }
}

extension UserPostViewModel {
    enum Action {
        case viewAppeared
        case refreshRequested
        case sortRequested(SortOption)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewAppeared:
            input.viewAppeared.send(())
        case .refreshRequested:
            input.refreshRequested.send(())
        case .sortRequested(let option):
            input.sortRequested.send(option)
        }
    }
}
