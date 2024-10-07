//
//  Review.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/29/24.
//

import RealmSwift
import Foundation

final class Review: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var rating: Double
    @Persisted var date: Date
    @Persisted var content: String
    @Persisted var restaurantName: String
    @Persisted var restaurantAddress: String
    @Persisted var latitude: String
    @Persisted var longitude: String
    @Persisted var imagePaths: List<String>
    @Persisted var category: String?
    
    convenience init(title: String, rating: Double, date: Date, content: String, restaurantName: String, restaurantAddress: String, latitude: String, longitude: String, imagePaths: [String], category: String? = nil) {
        self.init() 
        self.title = title
        self.rating = rating
        self.date = date
        self.content = content
        self.restaurantName = restaurantName
        self.restaurantAddress = restaurantAddress
        self.latitude = latitude
        self.longitude = longitude
        self.imagePaths.append(objectsIn: imagePaths)
        self.category = category
    }
}

