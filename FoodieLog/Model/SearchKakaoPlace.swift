//
//  SearchKakaoPlace.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/14/24.
//

import Foundation

struct SearchKakaoPlace: Decodable {
    let documents: [KakaoPlace]
       let meta: KakaoPlaceMeta
   }

   struct KakaoPlace: Decodable {
       let address_name: String
       let category_group_code: String
       let category_group_name: String
       let category_name: String
       let distance: String
       let id: String
       let phone: String
       let place_name: String
       let place_url: String
       let road_address_name: String
       let x: String
       let y: String
   }

   struct KakaoPlaceMeta: Decodable {
       let is_end: Bool
       let pageable_count: Int
       let same_name: KakaoPlaceSameName
       let total_count: Int
   }

   struct KakaoPlaceSameName: Decodable {
       let keyword: String
       let region: [String]
       let selected_region: String
   }

