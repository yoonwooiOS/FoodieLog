//
//  RealmManager.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/18/24.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    func configuration() -> Realm.Configuration {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    //스키마 버전 업데이트
                }
            }
        )
        return config
    }
}
