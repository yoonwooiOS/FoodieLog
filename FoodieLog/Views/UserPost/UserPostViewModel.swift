//
//  UserPostViewModel.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/6/24.
//

import Foundation
import Combine

class UserPostViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    private let reviewRepository: ReviewRepository
    
    init(reviewRepository: ReviewRepository = ReviewRepository()) {
        self.reviewRepository = reviewRepository
        transform()
    }
}

// MARK: - Input/Output

extension UserPostViewModel {
    struct Input {
        let viewAppeared = PassthroughSubject<Void, Never>()
        let refreshRequested = PassthroughSubject<Void, Never>()
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
    }
    
    private func refreshReviews() {
        output.isLoading = true
        DispatchQueue.main.async {
            self.output.reviews = self.reviewRepository.fetchAll().map { ReviewData(from: $0) }
            self.output.isLoading = false
        }
    }
}

// MARK: - Action

extension UserPostViewModel {
    enum Action {
        case viewAppeared
        case refreshRequested
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewAppeared:
            input.viewAppeared.send(())
        case .refreshRequested:
            input.refreshRequested.send(())
        }
    }
}
