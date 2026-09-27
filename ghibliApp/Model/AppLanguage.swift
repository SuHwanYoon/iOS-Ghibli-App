//
//  AppLanguage.swift
//  ghibliApp
//
//  Created by Antigravity on 2026/09/27.
//

import Foundation

/// 앱에서 지원하는 언어 및 로케일 매핑을 관리하는 열거형입니다.
enum AppLanguage: String, CaseIterable, Identifiable {
    case korean = "ko"
    case english = "en"
    case japanese = "ja"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .korean:
            return "한국어"
        case .english:
            return "English"
        case .japanese:
            return "日本語"
        }
    }

    var locale: Locale {
        Locale(identifier: rawValue)
    }
}
