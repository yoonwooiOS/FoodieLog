//
//  FoodieLogApp.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/12/24.
//

import SwiftUI
import KakaoMapsSDK

@main
struct MapViewTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
            SDKInitializer.InitSDK(appKey: kakaoAppKey)
        } else {
            fatalError("Kakao App Key is missing in Info.plist")
        }
        return true
    }
}
