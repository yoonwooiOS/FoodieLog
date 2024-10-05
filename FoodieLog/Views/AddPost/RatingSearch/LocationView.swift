//
//  LocationView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import SwiftUI

struct LocationView: View {
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "map")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.8))
                Text("지도에서 맛집을 검색하고 등록해보세요!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            .frame(width: 320, height: 100)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 1, x: 1, y: 1)
        }
    }
}


#Preview {
    LocationView()
}
