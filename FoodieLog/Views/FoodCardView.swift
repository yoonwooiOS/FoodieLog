//
//  FoodCardView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI

struct FoodCardView: View {
    var body: some View {
        ZStack {
            // 배경 이미지
            Image("Sancheong")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350, height: 250)
                .cornerRadius(20)
                .overlay(
                    VStack(alignment: .center, spacing: 5) {
                        Spacer()
                        HStack {
                            Spacer()
                            Label("한식", systemImage: "person")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("산청가든")
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            ForEach(0..<4) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                            }
                            Image(systemName: "star")
                                .foregroundColor(.orange)
                        }
                        Spacer()
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(20)
                    .frame(width: 300, height: 80)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.bottom, -30)
                    , alignment: .bottom
                )
        }
        .frame(width: 350, height: 280) // 전체 높이를 증가
        .padding()
    }
}
#Preview {
    FoodCardView()
}
