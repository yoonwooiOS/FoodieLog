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
            FoodCardView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                        .foregroundColor(selectedTab == 0 ? Color.blue : Color.gray)
                    Text("")
                }
                .tag(0)
            
            Text("Search View")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(selectedTab == 1 ? Color.blue : Color.gray)
                    Text("")
                }
                .tag(1)
    
            Text("Folder View")
                .tabItem {
                    Image(systemName: "calendar")
                        .foregroundColor(selectedTab == 2 ? Color.blue : Color.gray)
                    Text("")
                }
                .tag(2)
            
            Text("Profile View")
                .tabItem {
                    Image(systemName: "person")
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
