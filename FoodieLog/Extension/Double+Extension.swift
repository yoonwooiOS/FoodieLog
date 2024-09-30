//
//  Double+Extension.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/30/24.
//

import Foundation

extension Formatter {
    static let oneDecimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.roundingMode = .halfUp
        return formatter
    }()
}

extension Double {
    var oneDecimalString: String {
        return Formatter.oneDecimalFormatter.string(for: self) ?? ""
    }
}
