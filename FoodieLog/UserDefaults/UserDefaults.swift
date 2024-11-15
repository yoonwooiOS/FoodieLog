//
//  UserDefaults.swift
//  FoodieLog
//
//  Created by 김윤우 on 11/15/24.
//

import Foundation

enum UserDefaultsKeys: String {
    case reviewRating
    case restaurantName
    case reviewImage
}


@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultsKeys
    let defaultValue: T
    let storage: UserDefaults
    
    init(key: UserDefaultsKeys, defaultValue: T, storage: UserDefaults) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
    
    var wrappedValue: T {
        get { self.storage.object(forKey: key.rawValue) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: key.rawValue)}
    }
}
