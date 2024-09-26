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
}
