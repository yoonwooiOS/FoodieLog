//
//  PlaceService.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/20/24.
//

import SwiftUI
import CoreLocation

class PlaceService {
    let apiKey = APIKey.googleKey
    
    func searchNearbyRestaurants(latitude: Double, longitude: Double, completion: @escaping ([Place]?) -> Void) {
           let radius = 1500
           let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&type=restaurant&key=\(apiKey)"
           
           guard let url = URL(string: urlString) else {
               print("Invalid URL")
               completion(nil)
               return
           }
           
           URLSession.shared.dataTask(with: url) { data, response, error in
               if let error = error {
                   print("Error fetching restaurants: \(error.localizedDescription)")
                   completion(nil)
                   return
               }
               
               guard let data = data else {
                   print("No data returned from request")
                   completion(nil)
                   return
               }
               
               do {
                   let placeResponse = try JSONDecoder().decode(PlaceResponse.self, from: data)
                   completion(placeResponse.results)
               } catch {
                   print("Error decoding JSON: \(error.localizedDescription)")
                   completion(nil)
               }
           }.resume()
       }
   }

class PhotoService {
    let apiKey = APIKey.googleKey
    
    func fetchPlacePhoto(photoReference: String, maxWidth: Int = 400, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(maxWidth)&photoreference=\(photoReference)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL for photo reference")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching photo: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
