//
//  ReviewPostRepository.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/30/24.
//

import Foundation
import RealmSwift
import UIKit

final class ReviewRepository {
    private let realm = try! Realm()
    
    // CRUD operations
    func add(_ review: Review) {
        do {
            try realm.write {
                realm.add(review)
                print("Review added successfully.")
            }
        } catch {
            print("Error adding Review: \(error)")
        }
    }
    
    func fetchAll() -> [Review] {
        let reviews = realm.objects(Review.self)
            .sorted(byKeyPath: "date", ascending: false)
        return Array(reviews)
    }
    
    func fetch(by id: ObjectId) -> Review? {
        return realm.object(ofType: Review.self, forPrimaryKey: id)
    }
    
    func update(_ review: Review, with newValues: Review) {
        do {
            try realm.write {
                review.title = newValues.title
                review.rating = newValues.rating
                review.date = newValues.date
                review.content = newValues.content
                review.restaurantName = newValues.restaurantName
                review.restaurantAddress = newValues.restaurantAddress
                review.latitude = newValues.latitude
                review.longitude = newValues.longitude
                
                realm.add(review, update: .modified)
                print("Review updated successfully.")
            }
        } catch {
            print("Error updating Review: \(error)")
        }
    }
    
    func delete(_ review: Review) {
        autoreleasepool {
            do {
                let realm = try Realm()
                try realm.write {
                    // 이미지 파일 삭제
                    for imagePath in review.imagePaths {
                        ImageManager.shared.deleteImageFromDisk(imageName: imagePath)
                    }
                    realm.delete(review)
                }
                print("Review deleted successfully.")
            } catch {
                print("Error deleting Review: \(error)")
            }
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                let allReviews = realm.objects(Review.self)
                realm.delete(allReviews)
                print("All Reviews deleted successfully.")
            }
        } catch {
            print("Error deleting all Reviews: \(error)")
        }
    }
    
    func saveReviewWithImages(review: Review, images: [UIImage]) {
        var imagePaths: [String] = []
        
        for (index, image) in images.enumerated() {
            if let imageName = ImageManager.shared.saveImageToDisk(image: image, imageName: "review_image_\(index)_\(review.id.stringValue)") {
                imagePaths.append(imageName)
            }
        }
        
        do {
            try realm.write {
                review.imagePaths.append(objectsIn: imagePaths)
                realm.add(review)
            }
        } catch {
            print("Error saving review with images: \(error)")
        }
    }
    func fetchLatestFive() -> [ReviewData] {
        let reviews = realm.objects(Review.self)
            .sorted(byKeyPath: "date", ascending: false)
            .prefix(5)
        
        // LazyMapSequence를 명시적으로 배열로 변환
        let reviewDataList = Array(reviews.map { review in
            return ReviewData(from: review)
        })
        
        return reviewDataList
    }
    func detectRealmURL() {
        print("Realm file path: \(realm.configuration.fileURL?.absoluteString ?? "No file URL")")
    }
}
