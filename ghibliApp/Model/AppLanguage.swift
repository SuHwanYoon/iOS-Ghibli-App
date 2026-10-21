//
//  AppLanguage.swift
//  ghibliApp
//
//  Created by Antigravity on 2026/09/27.
//

import Foundation

/// 앱에서 지원하는 언어 및 로케일 매핑을 관리하는 열거형입니다.
enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "system"
    case korean = "ko"
    case english = "en"
    case japanese = "ja"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .system:
            return "시스템 설정"
        case .korean:
            return "한국어"
        case .english:
            return "English"
        case .japanese:
            return "日本語"
        }
    }

    /// 기기의 선호 언어 목록을 기반으로 지원 언어(ko, en, ja) 중 가장 적합한 언어를 감지합니다.
    static func preferredDeviceLanguage(
        from preferredLanguages: [String] = Locale.preferredLanguages,
        fallback: AppLanguage = .korean
    ) -> AppLanguage {
        for language in preferredLanguages {
            let lower = language.lowercased()
            if lower.hasPrefix("ko") {
                return .korean
            }
            if lower.hasPrefix("ja") {
                return .japanese
            }
            if lower.hasPrefix("en") {
                return .english
            }
        }
        return fallback
    }

    /// 실제 UI에 적용할 유효한 언어 코드("ko", "en", "ja")를 반환합니다.
    var effectiveLanguageCode: String {
        if self == .system {
            return AppLanguage.preferredDeviceLanguage().rawValue
        }
        return rawValue
    }

    var locale: Locale {
        Locale(identifier: effectiveLanguageCode)
    }

    /// 실제 언어 코드에 해당하는 .lproj 번들을 반환합니다.
    var bundle: Bundle {
        let code = effectiveLanguageCode
        let targetBundle = Bundle(for: FilmDetailViewModel.self)
        if let path = targetBundle.path(forResource: code, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            return langBundle
        }
        if let path = Bundle.main.path(forResource: code, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            return langBundle
        }
        return Bundle.main
    }

    /// 지정된 키에 대한 번역 문자열을 현재 언어 번들에서 직접 로드합니다.
    func localizedString(for key: String, comment: String = "") -> String {
        NSLocalizedString(key, bundle: self.bundle, comment: comment)
    }
}
