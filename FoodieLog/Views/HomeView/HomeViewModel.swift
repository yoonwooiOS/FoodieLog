//
//  HomeViewViewModel.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/5/24.
//
import Foundation
import Combine
import CoreLocation

class HomeViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    private let reviewRepository: ReviewRepository
    let locationManager: LocationManager
    
    init(reviewRepository: ReviewRepository = ReviewRepository(), locationManager: LocationManager = LocationManager()) {
        self.reviewRepository = reviewRepository
        self.locationManager = locationManager
        transform()
    }
}

// MARK: - Input/Output

extension HomeViewModel {
    struct Input {
        let viewAppeared = PassthroughSubject<Void, Never>()
        let refreshRequested = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var reviews: [ReviewData] = []
        var isLoading = true
        var locationAuthorizationStatus: CLAuthorizationStatus = .notDetermined
    }
    
    func transform() {
        input.viewAppeared
            .merge(with: input.refreshRequested)
            .sink { [weak self] _ in
                self?.refreshReviews()
            }
            .store(in: &cancellables)
        
        locationManager.$authorizationStatus
            .assign(to: \.output.locationAuthorizationStatus, on: self)
            .store(in: &cancellables)
    }
    
    private func refreshReviews() {
        print("refreshRevies")
        output.isLoading = true
        locationManager.requestLocationPermission()
        DispatchQueue.main.async {
            self.output.reviews = self.reviewRepository.fetchLatestFive()
        }
       
        output.isLoading = false
    }
}

// MARK: - Action

extension HomeViewModel {
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
