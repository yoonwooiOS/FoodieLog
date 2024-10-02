//
//  ColorSet.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import SwiftUI

enum ColorSet {
    case primary
    case lightGray
    case lightMint
    case lightBlue
    case lightPink
    case beige
    case darkGray
    case darkNavy
    case cream

    var color: Color {
        switch self {
        case .primary:
            return Color(hex: "f7f4ea")
        case .lightGray:
            return Color(red: 240/255, green: 240/255, blue: 240/255) // #F0F0F0
        case .lightMint:
            return Color(red: 224/255, green: 247/255, blue: 236/255) // #E0F7EC
        case .lightBlue:
            return Color(red: 224/255, green: 242/255, blue: 255/255) // #E0F2FF
        case .lightPink:
            return Color(red: 255/255, green: 224/255, blue: 230/255) // #FFE0E6
        case .beige:
            return Color(red: 250/255, green: 243/255, blue: 224/255) // #FAF3E0
        case .darkGray:
            return Color(red: 44/255, green: 62/255, blue: 80/255)    // #2C3E50
        case .darkNavy:
            return Color(red: 52/255, green: 73/255, blue: 94/255)    // #34495E
        case .cream:
            return Color(red: 255/255, green: 248/255, blue: 231/255) // #FFF8E7
        }
    }
}
