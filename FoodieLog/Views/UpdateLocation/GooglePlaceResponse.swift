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

struct Place: Decodable, Hashable {
    let name: String
    let vicinity: String?
    let placeID: String
    let photos: [PlacePhoto]?

    enum CodingKeys: String, CodingKey {
        case name
        case vicinity
        case placeID = "place_id"
        case photos
    }
}

struct PlacePhoto: Decodable, Hashable {
    let photoReference: String

    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
