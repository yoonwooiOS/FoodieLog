//
//  NavigationDestination.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import Foundation

enum NavigationDestination: Hashable {
    case rateView
    case addPost(rating: Double, place: Place?)
}
