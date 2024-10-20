//
//  LaunchScreenView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/18/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            HomeTabView()
        } else {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        if !isActive {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                }
        }
    }
}
