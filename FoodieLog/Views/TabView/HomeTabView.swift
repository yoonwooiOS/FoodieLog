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
    var body: some View {
            TabView(selection: $selectedTab) {
                NavigationStack(path: $path) {
                    HomeView(path: $path)
                }
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("")
                }
                .tag(0)

                UserPostView()
                    .tabItem {
                        Image(systemName: "folder")
                        Text("")
                    }
                    .tag(1)

                SettingView()
                    .tabItem {
                        Image(systemName: selectedTab == 2 ? "gearshape.fill" : "gearshape")
                        Text("")
                    }
                    .tag(2)
                
//                Text("Chart View")
                //                .tabItem {
                //                    Image(systemName: "chart.pie")
                //                        .foregroundColor(selectedTab == 3 ? Color.blue : Color.gray)
                //                    Text("")
                //                }
                //                .tag(3)

            }
            .accentColor(Color(hex: "d4a373"))
        }
}
#Preview {
    HomeTabView()
}
