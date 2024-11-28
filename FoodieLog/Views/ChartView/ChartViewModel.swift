//
//  ChartViewModel.swift
//  FoodieLog
//
//  Created by 김윤우 on 11/27/24.
//

import Foundation
import Combine

final class ChartViewModel: ViewModelType {
    var input: Input
    @Published var output: Output
    var cancellables: Set<AnyCancellable> = []

    private let reviewRepository: ReviewRepository

    init(reviewRepository: ReviewRepository = ReviewRepository()) {
        self.input = Input()
        self.output = Output(
            reviewData: [],
            filteredCategoryData: [],
            selectedMonth: Calendar.current.component(.month, from: Date()),
            selectedYear: Calendar.current.component(.year, from: Date()),
            isLoading: true,
            resultCategory: ""
        )
        self.reviewRepository = reviewRepository
        transform()
    }
}

extension ChartViewModel {
    struct Input {
        let onAppear = PassthroughSubject<Void, Never>()
        let changeMonth = PassthroughSubject<Int, Never>()
    }
    
    struct Output {
        var reviewData: [Review]
        var filteredCategoryData: [FoodCategoryData]
        var selectedMonth: Int
        var selectedYear: Int
        var isLoading: Bool
        var resultCategory: String
        var formattedYear: String {
            String(selectedYear)
        }
        
    }
    
    func transform() {
        // 초기 데이터 로드
        input.onAppear
            .sink { [weak self] in
                self?.fetchReviewsAndFilter()
            }
            .store(in: &cancellables)
        
        // 월 변경 처리
        input.changeMonth
            .sink { [weak self] value in
                self?.updateMonth(by: value)
            }
            .store(in: &cancellables)
    }
    
    private func fetchReviewsAndFilter() {
        setLoadingState(true)
        
        // 리뷰 데이터 가져오기
        loadReviews { [weak self] reviews in
            self?.output.reviewData = reviews
            self?.filterReviewsAndUpdateState()
            self?.setLoadingState(false)
        }
    }
    
    // 리뷰 데이터 로드
    private func loadReviews(completion: @escaping ([Review]) -> Void) {
        let reviews = self.reviewRepository.fetchAll()
        DispatchQueue.main.async {
            completion(reviews)
        }
    }
    
    // 리뷰 데이터를 필터링하고 상태 업데이트
    private func filterReviewsAndUpdateState() {
        let filteredReviews = filterReviews(output.reviewData)
        output.filteredCategoryData = processFilteredReviews(filteredReviews)
        output.resultCategory = output.filteredCategoryData.first?.category ?? ""
    }
    
    // 현재 선택된 월과 연도 기준으로 리뷰 필터링
    private func filterReviews(_ reviews: [Review]) -> [Review] {
        return reviews.filter { review in
            let reviewDateComponents = Calendar.current.dateComponents([.year, .month], from: review.date)
            return reviewDateComponents.year == output.selectedYear &&
                   reviewDateComponents.month == output.selectedMonth
        }
    }
    
    // 필터링된 리뷰 데이터를 카테고리별로 그룹화하고 정렬
    private func processFilteredReviews(_ filteredReviews: [Review]) -> [FoodCategoryData] {
        return Array(
              Dictionary(grouping: filteredReviews) { $0.category }
                  .map { FoodCategoryData(category: $0.key, count: $0.value.count) }
                  .sorted { $0.count > $1.count }
                  .prefix(5) // ArraySlice를 반환
          )
      }
    
    // 월 변경 처리
    private func updateMonth(by value: Int) {
        guard let newDate = Calendar.current.date(byAdding: .month, value: value, to: getCurrentDate()) else { return }
        output.selectedMonth = Calendar.current.component(.month, from: newDate)
        output.selectedYear = Calendar.current.component(.year, from: newDate)
        filterReviewsAndUpdateState()
    }
    
    // 로딩 상태를 업데이트
    private func setLoadingState(_ isLoading: Bool) {
        output.isLoading = isLoading
    }
    
    // 현재 날짜 가져오기
    private func getCurrentDate() -> Date {
        let components = DateComponents(year: output.selectedYear, month: output.selectedMonth)
        return Calendar.current.date(from: components) ?? Date()
    }
}

extension ChartViewModel {
    enum Action {
        case onAppear
        case changeMonth(Int)
    }

    func action(_ action: Action) {
        switch action {
        case .onAppear:
            input.onAppear.send(())
        case .changeMonth(let value):
            input.changeMonth.send(value)
        }
    }
}

struct FoodCategoryData: Identifiable {
    let id = UUID()
    let category: String
    let count: Int
}

extension ChartViewModel {
    // 특정 카테고리와 월, 연도에 해당하는 리뷰 반환
    func reviewsForCategory(_ category: String, month: Int, year: Int) -> [Review] {
        return output.reviewData.filter { review in
            let reviewDateComponents = Calendar.current.dateComponents([.year, .month], from: review.date)
            return review.category == category &&
                   reviewDateComponents.year == year &&
                   reviewDateComponents.month == month
        }
    }
}

