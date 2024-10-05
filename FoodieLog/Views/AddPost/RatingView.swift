//
//  RatingView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/25/24.
//

import SwiftUI
import Cosmos

struct RatingView: UIViewRepresentable {
    @Binding var rating: Double
    var starSize: Double?
    var isInteractive: Bool 

    func makeUIView(context: Context) -> CosmosView {
        let cosmosView = CosmosView()
        cosmosView.settings.fillMode = .half
        cosmosView.settings.starSize = starSize ?? 40
        cosmosView.settings.updateOnTouch = isInteractive
        cosmosView.settings.minTouchRating = 0

        if isInteractive {
            cosmosView.didFinishTouchingCosmos = { value in
                rating = value
            }
        }

        return cosmosView
    }

    func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating
        uiView.settings.updateOnTouch = isInteractive
    }
}
