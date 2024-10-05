//
//  FoodieLogApp.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
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
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
        }
    }
}

@main
struct FoodieLogApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
        }
    }
}
