//
//  SplashView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/4/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white.ignoresSafeArea()
                Image("‎FoodieLog")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 320, height: 320)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
            }
        }
    }
}
