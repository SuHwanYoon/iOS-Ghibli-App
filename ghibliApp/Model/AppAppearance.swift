//
//  AppAppearance.swift
//  ghibliApp
//
//  Created by Antigravity on 2026/10/18.
//

import Foundation
import SwiftUI

/// 앱의 화면 테마(외관 모드)를 정의하는 열거형입니다.
enum AppAppearance: String, CaseIterable, Identifiable, Sendable {
    case system = "system"
    case light = "light"
    case dark = "dark"

    var id: String { rawValue }

    /// UserDefaults 및 AppStorage 저장용 키
    static let storageKey = "appAppearance"

    /// SwiftUI의 `preferredColorScheme`에 적용할 ColorScheme 옵셔널 값입니다.
    /// .system인 경우 시스템 설정을 그대로 따르도록 nil을 반환합니다.
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    /// String Catalog 다국어 리소스 키입니다.
    var localizationKey: String {
        switch self {
        case .system:
            return "appearance_system"
        case .light:
            return "appearance_light"
        case .dark:
            return "appearance_dark"
        }
    }

    /// 기본 표시 텍스트(한국어)입니다.
    var displayName: String {
        switch self {
        case .system:
            return "시스템 설정"
        case .light:
            return "라이트 모드"
        case .dark:
            return "다크 모드"
        }
    }

    /// SwiftUI에서 직접 사용할 수 있는 LocalizedStringKey
    var titleKey: LocalizedStringKey {
        LocalizedStringKey(localizationKey)
    }

    /// SF Symbol 아이콘 이름
    var iconName: String {
        switch self {
        case .system:
            return "circle.righthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }

    /// 아이콘 배경 틴트 색상
    var iconTintColor: Color {
        switch self {
        case .system:
            return .blue
        case .light:
            return .orange
        case .dark:
            return .indigo
        }
    }

    /// VoiceOver 접근성 힌트 다국어 키
    var accessibilityHintKey: LocalizedStringKey {
        switch self {
        case .system:
            return "appearance_system_accessibility_hint"
        case .light:
            return "appearance_light_accessibility_hint"
        case .dark:
            return "appearance_dark_accessibility_hint"
        }
    }

    /// 유효하지 않거나 nil인 rawValue를 안전하게 기본값(.system)으로 복구하는 생성자입니다.
    init(fromRawValue rawValue: String?) {
        guard let rawValue = rawValue, let matched = AppAppearance(rawValue: rawValue) else {
            self = .system
            return
        }
        self = matched
    }

    /// static 헬퍼 메서드로 안전한 인스턴스를 반환합니다.
    static func from(rawValue: String?) -> AppAppearance {
        AppAppearance(fromRawValue: rawValue)
    }
}

// MARK: - UIKit UIWindow Bridge (Real Device Theme Support)

#if canImport(UIKit)
import UIKit

extension AppAppearance {
    /// UIKit의 `UIUserInterfaceStyle`에 대응하는 값입니다.
    /// .system은 시스템 기본 설정을 따르도록 .unspecified를 반환합니다.
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    /// 현재 저장된 테마를 불러와 모든 활성 윈도우에 즉시 적용합니다.
    @MainActor
    static func applyCurrentTheme() {
        let raw = UserDefaults.standard.string(forKey: storageKey)
        let appearance = AppAppearance.from(rawValue: raw)
        appearance.apply()
    }

    /// 이 외관 모드를 모든 활성 윈도우의 overrideUserInterfaceStyle에 즉시 강제 적용합니다.
    /// 실기기에서 다크 모드 전환 후 라이트 모드로 돌아가지 않는 SwiftUI 프레임워크 한계를 완벽히 해결합니다.
    @MainActor
    func apply() {
        let scenes = UIApplication.shared.connectedScenes
        for scene in scenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = self.userInterfaceStyle
            }
        }
    }
}
#endif
