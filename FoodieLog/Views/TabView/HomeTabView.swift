//
//  HomeTabView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/16/24.
//

import SwiftUI


struct HomeTabView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
           HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .foregroundColor(selectedTab == 0 ? Color.blue : Color.gray)
                    Text("")
                }
                .tag(0)
            
            AddPostView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(selectedTab == 1 ? Color.blue : Color.gray)
                    Text("")
                }
                .tag(1)
            
            CalenderView()
                .tabItem {
                    Image(systemName: "calendar")
                        .foregroundColor(selectedTab == 2 ? Color.blue : Color.gray)
                    Text("")
                }
                .tag(2)
            
            Text("Chart View")
                .tabItem {
                    Image(systemName: "chart.pie")
                        .foregroundColor(selectedTab == 3 ? Color.blue : Color.gray)
                    Text("")
                }
                .tag(3)
        }
        .accentColor(.purple)
    }
}
#Preview {
    HomeTabView()
}
