//
//  GooglePlaceResponse.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/20/24.
//

import Foundation

struct PlaceResponse: Decodable {
    let results: [Place]
}

struct Place: Identifiable, Hashable, Decodable {
    let id = UUID()
    let name: String
    let vicinity: String?
    let placeID: String
    let formattedAddress: String?
    let photos: [PlacePhoto]?
    let geometry: Geometry 

    enum CodingKeys: String, CodingKey {
        case name
        case vicinity
        case placeID = "place_id"
        case photos
        case geometry
        case formattedAddress = "formatted_address"
    }
}

struct PlacePhoto: Decodable, Hashable {
    let photoReference: String

    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}

struct Geometry: Decodable, Hashable {
    let location: Location
}

struct Location: Decodable, Hashable {
    let lat: Double
    let lng: Double
}
