//
//  WidgetDataManager.swift
//  FoodieLog
//
//  Created by 김윤우 on 11/15/24.
//

import Foundation

final class PostDataManager {
    @UserDefault(key: .reviewRating, defaultValue: 0.0, storage: UserDefaults(suiteName: AppGroups.key)!)
    var userRating: Double

    @UserDefault(key: .restaurantName, defaultValue: "", storage: UserDefaults(suiteName: AppGroups.key)!)
    var restaurantName: String

    @UserDefault(key: .reviewImage, defaultValue: "", storage: UserDefaults(suiteName: AppGroups.key)!)
    var restaurantImageDataPath: String
    
    
}
