//
//  HomeView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("최근 방문한 맛집")
                    Spacer()
                }
                .font(.title2)
                .bold()
                .padding(.leading, 20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<5) { _ in
                            FoodCardView()
                        }
                    }
                }
                .padding(.top, -30)
            }
            .navigationTitle("맛집 Log")
        }
        
    }
}

#Preview {
    HomeView()
}
