//
//  ghibliAppApp.swift
//  ghibliApp
//
//  Created by YOON on 1/9/26.
//

import SwiftUI

@main
struct ghibliAppApp: App {
    init() {
        // 앱 시작 시 저장된 화면 모드를 UIWindow 레벨에 즉시 적용
        AppAppearance.applyCurrentTheme()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
