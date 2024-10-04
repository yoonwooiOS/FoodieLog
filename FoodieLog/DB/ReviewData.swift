//
//  ReviewData.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/3/24.
//

import RealmSwift
import Foundation

struct ReviewData: Hashable {
    var id: ObjectId
    var title: String
    var rating: Double
    var date: Date
    var content: String
    var restaurantName: String
    var restaurantAddress: String
    var latitude: String
    var longitude: String
    var imagePaths: [String]
    
    init(from review: Review) {
        self.id = review.id
        self.title = review.title
        self.rating = review.rating
        self.date = review.date
        self.content = review.content
        self.restaurantName = review.restaurantName
        self.restaurantAddress = review.restaurantAddress
        self.latitude = review.latitude
        self.longitude = review.longitude
        self.imagePaths = Array(review.imagePaths)
    }

    
    func toReview() -> Review {
        let review = Review()
        review.title = self.title
        review.content = self.content
        review.rating = self.rating
        review.date = self.date
        review.restaurantName = self.restaurantName
        review.restaurantAddress = self.restaurantAddress
        review.latitude = self.latitude
        review.longitude = self.longitude
        review.imagePaths.append(objectsIn: self.imagePaths)
        return review
    }
}
