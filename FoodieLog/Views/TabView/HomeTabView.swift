//
//  HomeTabView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/16/24.
//

import SwiftUI


struct HomeTabView: View {
    @State private var path = NavigationPath()
    @State private var selectedTab = 0
    init() {
        setupTabBarAppearance()
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                HomeView(path: $path)
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("홈")
            }
            .tag(0)
            
            UserPostView(path: $path)
                .tabItem {
                    Image(systemName: "folder")
                    Text("리뷰")
                }
                .tag(1)
            
            ChartView()
                .tabItem {
                    Image(systemName: "chart.pie")
                        .foregroundColor(selectedTab == 3 ? Color.blue : Color.gray)
                    Text("차트")
                }
                .tag(2)
            
            NavigationStack(path: $path) {
                SettingView()
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "gearshape.fill" : "gearshape")
                Text("설정")
            }
            .tag(3)
            
        }
        .accentColor(ColorSet.tab.color)
    }
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "#EBEBEB")) // TabView 배경색
        
        // 설정을 TabBar에 적용
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().barTintColor = UIColor(Color(hex: "#EBEBEB"))
    }
}
#Preview {
    HomeTabView()
}
