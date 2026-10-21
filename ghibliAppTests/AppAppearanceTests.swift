//
//  AppAppearanceTests.swift
//  ghibliAppTests
//
//  Created by Antigravity on 2026/10/18.
//

import Foundation
import SwiftUI
import Testing
@testable import ghibliApp

@Suite("AppAppearance Model and Theme Tests")
struct AppAppearanceTests {

    // MARK: - 1. Model Structure & Property Tests

    @Test("AppAppearance cases, rawValues, and IDs are properly configured")
    func testAppAppearanceProperties() {
        let allCases = AppAppearance.allCases
        
        // 1. case 개수 확인 (system, light, dark 총 3가지)
        #expect(allCases.count == 3)

        // 2. rawValue 및 id 매핑 확인
        #expect(AppAppearance.system.rawValue == "system")
        #expect(AppAppearance.system.id == "system")

        #expect(AppAppearance.light.rawValue == "light")
        #expect(AppAppearance.light.id == "light")

        #expect(AppAppearance.dark.rawValue == "dark")
        #expect(AppAppearance.dark.id == "dark")
    }

    @Test("ColorScheme mapping returns correct optional value for each mode")
    func testColorSchemeMapping() {
        // .system은 시스템 설정을 따르도록 nil이어야 함
        #expect(AppAppearance.system.colorScheme == nil)

        // .light는 SwiftUI의 .light ColorScheme이어야 함
        #expect(AppAppearance.light.colorScheme == .light)

        // .dark는 SwiftUI의 .dark ColorScheme이어야 함
        #expect(AppAppearance.dark.colorScheme == .dark)
    }

    #if canImport(UIKit)
    @Test("UIUserInterfaceStyle mapping returns correct style for UIKit bridge")
    func testUIUserInterfaceStyleMapping() {
        #expect(AppAppearance.system.userInterfaceStyle == .unspecified)
        #expect(AppAppearance.light.userInterfaceStyle == .light)
        #expect(AppAppearance.dark.userInterfaceStyle == .dark)
    }
    #endif

    @Test("displayName and localization keys are mapped correctly")
    func testDisplayNameAndLocalizationKeys() {
        #expect(AppAppearance.system.displayName == "시스템 설정")
        #expect(AppAppearance.system.localizationKey == "appearance_system")

        #expect(AppAppearance.light.displayName == "라이트 모드")
        #expect(AppAppearance.light.localizationKey == "appearance_light")

        #expect(AppAppearance.dark.displayName == "다크 모드")
        #expect(AppAppearance.dark.localizationKey == "appearance_dark")
    }

    @Test("UI helper properties (icons and colors) are correctly configured")
    func testAppAppearanceUIProperties() {
        #expect(AppAppearance.system.iconName == "circle.righthalf.filled")
        #expect(AppAppearance.system.iconTintColor == .blue)

        #expect(AppAppearance.light.iconName == "sun.max.fill")
        #expect(AppAppearance.light.iconTintColor == .orange)

        #expect(AppAppearance.dark.iconName == "moon.fill")
        #expect(AppAppearance.dark.iconTintColor == .indigo)
    }

    // MARK: - 2. UserDefaults & State Restoration Tests

    @Test("UserDefaults state persistence and restoration across separate suite")
    func testUserDefaultsStateRestoration() {
        let suiteName = "AppearanceTestIsolationSuite_\(UUID().uuidString)"
        guard let testDefaults = UserDefaults(suiteName: suiteName) else {
            Issue.record("Failed to initialize isolated UserDefaults suite")
            return
        }

        defer {
            testDefaults.removePersistentDomain(forName: suiteName)
        }

        // 1. 기본 상태 (UserDefaults에 아무것도 저장되지 않은 경우)
        let initialRaw = testDefaults.string(forKey: AppAppearance.storageKey)
        #expect(initialRaw == nil)
        let initialResolved = AppAppearance.from(rawValue: initialRaw)
        #expect(initialResolved == .system, "Unset UserDefaults value should safely resolve to .system")

        // 2. 다크 모드 저장 및 복원 확인
        testDefaults.set(AppAppearance.dark.rawValue, forKey: AppAppearance.storageKey)
        let restoredDarkRaw = testDefaults.string(forKey: AppAppearance.storageKey)
        let restoredDarkMode = AppAppearance.from(rawValue: restoredDarkRaw)
        #expect(restoredDarkMode == .dark)
        #expect(restoredDarkMode.colorScheme == .dark)

        // 3. 라이트 모드 저장 및 복원 확인
        testDefaults.set(AppAppearance.light.rawValue, forKey: AppAppearance.storageKey)
        let restoredLightRaw = testDefaults.string(forKey: AppAppearance.storageKey)
        let restoredLightMode = AppAppearance.from(rawValue: restoredLightRaw)
        #expect(restoredLightMode == .light)
        #expect(restoredLightMode.colorScheme == .light)

        // 4. 시스템 모드 저장 및 복원 확인
        testDefaults.set(AppAppearance.system.rawValue, forKey: AppAppearance.storageKey)
        let restoredSystemRaw = testDefaults.string(forKey: AppAppearance.storageKey)
        let restoredSystemMode = AppAppearance.from(rawValue: restoredSystemRaw)
        #expect(restoredSystemMode == .system)
        #expect(restoredSystemMode.colorScheme == nil)

        // 5. 키 삭제 시 기본값 .system으로의 정상 복귀 확인
        testDefaults.removeObject(forKey: AppAppearance.storageKey)
        let clearedRaw = testDefaults.string(forKey: AppAppearance.storageKey)
        #expect(AppAppearance.from(rawValue: clearedRaw) == .system)
    }

    // MARK: - 3. Chaos Inputs & Edge Case Fallback Tests

    @Test("Edge cases and corrupted rawValues safely fallback to .system")
    func testCorruptedRawValuesFallbackSafely() {
        // nil 입력
        #expect(AppAppearance.from(rawValue: nil) == .system)

        // 빈 문자열 및 공백 문자열
        #expect(AppAppearance.from(rawValue: "") == .system)
        #expect(AppAppearance.from(rawValue: "   ") == .system)
        #expect(AppAppearance.from(rawValue: "\n\t") == .system)

        // 대소문자 불일치
        #expect(AppAppearance.from(rawValue: "DARK") == .system)
        #expect(AppAppearance.from(rawValue: "Dark") == .system)
        #expect(AppAppearance.from(rawValue: "LIGHT") == .system)
        #expect(AppAppearance.from(rawValue: "SYSTEM") == .system)

        // 미지원 임의 문자열
        #expect(AppAppearance.from(rawValue: "auto") == .system)
        #expect(AppAppearance.from(rawValue: "high_contrast") == .system)
        #expect(AppAppearance.from(rawValue: "sepia") == .system)

        // 특수문자 및 스크립트 인젝션 방어
        #expect(AppAppearance.from(rawValue: "!@#$%^&*()_+-=[]{}|;':,.<>?/") == .system)
        #expect(AppAppearance.from(rawValue: "<script>alert('xss')</script>") == .system)

        // 초장문 극한 입력값 (1,000자 이상)
        let extremeInput = String(repeating: "chaos_theme_injection_", count: 50)
        #expect(AppAppearance.from(rawValue: extremeInput) == .system)

        // 이니셜라이저 직접 호출 검증
        let initializedFromGarbage = AppAppearance(fromRawValue: "garbage_value")
        #expect(initializedFromGarbage == .system)
    }

    // MARK: - 4. String Catalog Localization Consistency Tests

    @Test("Appearance localization keys exist in String Catalog for ko, en, and ja")
    func testAppearanceLocalizationConsistency() throws {
        let appBundle = Bundle(for: FilmDetailViewModel.self)

        let supportedLocales = ["ko", "en", "ja"]
        let requiredKeys = [
            "settings_section_appearance",
            "appearance_system",
            "appearance_light",
            "appearance_dark",
            "settings_appearance_footer",
            "appearance_system_accessibility_hint",
            "appearance_light_accessibility_hint",
            "appearance_dark_accessibility_hint"
        ]

        for localeCode in supportedLocales {
            let lprojPath = try #require(
                appBundle.path(forResource: localeCode, ofType: "lproj"),
                "Missing lproj for \(localeCode)"
            )
            let localizedBundle = try #require(
                Bundle(path: lprojPath),
                "Failed to load Bundle for \(localeCode)"
            )

            for key in requiredKeys {
                let localizedValue = NSLocalizedString(key, bundle: localizedBundle, comment: "")
                #expect(!localizedValue.isEmpty, "Key '\(key)' should not be empty for locale \(localeCode)")
                #expect(localizedValue != key, "Key '\(key)' should be translated, not returned as key name")
            }
        }
    }
}
