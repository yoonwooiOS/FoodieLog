//
//  FoodieLogApp.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI
import RealmSwift
@main
struct FoodieLogApp: SwiftUI.App {
    init() {
        let config = RealmManager.shared.configuration()
        Realm.Configuration.defaultConfiguration = config
        
        do {
            _ = try Realm()
            print("Realm 초기화 성공")
        } catch {
            print("Realm 초기화 실패: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
        }
    }
}
