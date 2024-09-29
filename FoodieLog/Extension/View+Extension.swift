//
//  View+Extension.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/25/24.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: String(Locale.preferredLanguages[0]))
        return formatter.string(from: date)
    }
    
}
