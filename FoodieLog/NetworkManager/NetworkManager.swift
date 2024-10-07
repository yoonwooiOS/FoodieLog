//
//  NetworkManager.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/19/24.
//

import Foundation
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let apiKey = APIKey.googleKey
    
    // MARK: - Google Places Text Search API
    func searchGooglePlaces(for query: String, completion: @escaping ([Place]?) -> Void) {
        guard !query.isEmpty else {
            completion(nil)
            return
        }

        let urlString = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(query)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid Google URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Google places: \(error)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PlaceResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.results)
                }
            } catch {
                print("Error decoding Google response: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    // MARK: - Google Nearby Search API
    func searchGoogleNearbyRestaurants(latitude: Double, longitude: Double, radius: Int = 500, completion: @escaping ([Place]?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&type=restaurant&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid Google URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching Google places: \(error)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(PlaceResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.results)
                }
            } catch {
                print("Error decoding Google response: \(error)")
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }
    
    // MARK: - Google Place Photo API
    func fetchGooglePlacePhoto(photoReference: String, maxWidth: Int = 400, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(maxWidth)&photoreference=\(photoReference)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid Google photo URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching photo: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Non-200 status code")
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
