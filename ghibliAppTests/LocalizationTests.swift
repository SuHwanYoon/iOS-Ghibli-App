//
//  LocalizationTests.swift
//  ghibliAppTests
//
//  Created by Antigravity on 2026/09/27.
//

import Foundation
import Testing
@testable import ghibliApp

struct LocalizationTests {

    @Test("AppLanguage cases and properties are configured correctly")
    func testAppLanguageProperties() {
        let languages = AppLanguage.allCases
        #expect(languages.count == 4)
        
        #expect(AppLanguage.system.rawValue == "system")
        #expect(AppLanguage.system.displayName == "시스템 설정")
        
        #expect(AppLanguage.korean.rawValue == "ko")
        #expect(AppLanguage.korean.displayName == "한국어")
        #expect(AppLanguage.korean.locale.identifier == "ko")
        
        #expect(AppLanguage.english.rawValue == "en")
        #expect(AppLanguage.english.displayName == "English")
        #expect(AppLanguage.english.locale.identifier == "en")
        
        #expect(AppLanguage.japanese.rawValue == "ja")
        #expect(AppLanguage.japanese.displayName == "日本語")
        #expect(AppLanguage.japanese.locale.identifier == "ja")
    }

    @Test("Device language detection detects correct supported language and falls back properly")
    func testDeviceLanguageDetection() {
        // Korean primary
        let koDetected = AppLanguage.preferredDeviceLanguage(from: ["ko-KR", "en-US"])
        #expect(koDetected == .korean)
        
        // Japanese primary
        let jaDetected = AppLanguage.preferredDeviceLanguage(from: ["ja-JP", "en-US"])
        #expect(jaDetected == .japanese)
        
        // English primary
        let enDetected = AppLanguage.preferredDeviceLanguage(from: ["en-US", "ko-KR"])
        #expect(enDetected == .english)
        
        // Unsupported languages fallback to Korean
        let fallbackDetected = AppLanguage.preferredDeviceLanguage(from: ["fr-FR", "de-DE"])
        #expect(fallbackDetected == .korean)
        
        // Custom fallback
        let customFallback = AppLanguage.preferredDeviceLanguage(from: ["fr-FR"], fallback: .english)
        #expect(customFallback == .english)
    }

    @Test("Effective language code resolves properly for system and fixed cases")
    func testEffectiveLanguageResolution() {
        #expect(AppLanguage.korean.effectiveLanguageCode == "ko")
        #expect(AppLanguage.english.effectiveLanguageCode == "en")
        #expect(AppLanguage.japanese.effectiveLanguageCode == "ja")
        
        let systemEffective = AppLanguage.system.effectiveLanguageCode
        #expect(["ko", "en", "ja"].contains(systemEffective))
        #expect(AppLanguage.system.locale.identifier == systemEffective)
    }

    @Test("AppLanguage.localizedString returns the exact translation for each language")
    func testAppLanguageLocalizedString() {
        #expect(AppLanguage.korean.localizedString(for: "films_navigation_title") == "지브리 영화 리스트")
        #expect(AppLanguage.english.localizedString(for: "films_navigation_title") == "Ghibli Film List")
        #expect(AppLanguage.japanese.localizedString(for: "films_navigation_title") == "ジブリ映画リスト")
    }

    @Test("String Catalog provides valid translations for each language")
    func testStringCatalogTranslations() throws {
        let appBundle = Bundle(for: FilmDetailViewModel.self)
        
        // Korean bundle test
        let koPath = try #require(appBundle.path(forResource: "ko", ofType: "lproj"))
        let koBundle = try #require(Bundle(path: koPath))
        let koCharacters = NSLocalizedString("film_detail_characters_title", bundle: koBundle, comment: "")
        let koEmpty = NSLocalizedString("film_detail_no_characters", bundle: koBundle, comment: "")
        let koTabMovies = NSLocalizedString("tab_movies", bundle: koBundle, comment: "")
        let koSystem = NSLocalizedString("language_system", bundle: koBundle, comment: "")
        let koFilmsTitle = NSLocalizedString("films_navigation_title", bundle: koBundle, comment: "")
        #expect(koCharacters == "등장인물")
        #expect(koEmpty == "등장인물 정보가 없습니다.")
        #expect(koTabMovies == "영화")
        #expect(koSystem == "시스템 설정")
        #expect(koFilmsTitle == "지브리 영화 리스트")
        
        // English bundle test
        let enPath = try #require(appBundle.path(forResource: "en", ofType: "lproj"))
        let enBundle = try #require(Bundle(path: enPath))
        let enCharacters = NSLocalizedString("film_detail_characters_title", bundle: enBundle, comment: "")
        let enEmpty = NSLocalizedString("film_detail_no_characters", bundle: enBundle, comment: "")
        let enTabMovies = NSLocalizedString("tab_movies", bundle: enBundle, comment: "")
        let enSystem = NSLocalizedString("language_system", bundle: enBundle, comment: "")
        let enFilmsTitle = NSLocalizedString("films_navigation_title", bundle: enBundle, comment: "")
        #expect(enCharacters == "Characters")
        #expect(enEmpty == "No character information available.")
        #expect(enTabMovies == "Movies")
        #expect(enSystem == "System Default")
        #expect(enFilmsTitle == "Ghibli Film List")
        
        // Japanese bundle test
        let jaPath = try #require(appBundle.path(forResource: "ja", ofType: "lproj"))
        let jaBundle = try #require(Bundle(path: jaPath))
        let jaCharacters = NSLocalizedString("film_detail_characters_title", bundle: jaBundle, comment: "")
        let jaEmpty = NSLocalizedString("film_detail_no_characters", bundle: jaBundle, comment: "")
        let jaTabMovies = NSLocalizedString("tab_movies", bundle: jaBundle, comment: "")
        let jaSystem = NSLocalizedString("language_system", bundle: jaBundle, comment: "")
        let jaFilmsTitle = NSLocalizedString("films_navigation_title", bundle: jaBundle, comment: "")
        #expect(jaCharacters == "登場人物")
        #expect(jaEmpty == "登場人物の情報がありません。")
        #expect(jaTabMovies == "映画")
        #expect(jaSystem == "システム設定")
        #expect(jaFilmsTitle == "ジブリ映画リスト")
    }

    @Test("App display name is localized properly in InfoPlist and Localizable catalogs")
    func testAppNameLocalization() throws {
        let appBundle = Bundle(for: FilmDetailViewModel.self)
        
        // Korean test
        let koPath = try #require(appBundle.path(forResource: "ko", ofType: "lproj"))
        let koBundle = try #require(Bundle(path: koPath))
        let koDisplayName = koBundle.localizedInfoDictionary?["CFBundleDisplayName"] as? String
            ?? NSLocalizedString("CFBundleDisplayName", tableName: "InfoPlist", bundle: koBundle, comment: "")
        let koAppName = NSLocalizedString("app_name", bundle: koBundle, comment: "")
        #expect(koDisplayName == "지브리모음")
        #expect(koAppName == "지브리모음")
        
        // English test
        let enPath = try #require(appBundle.path(forResource: "en", ofType: "lproj"))
        let enBundle = try #require(Bundle(path: enPath))
        let enDisplayName = enBundle.localizedInfoDictionary?["CFBundleDisplayName"] as? String
            ?? NSLocalizedString("CFBundleDisplayName", tableName: "InfoPlist", bundle: enBundle, comment: "")
        let enAppName = NSLocalizedString("app_name", bundle: enBundle, comment: "")
        #expect(enDisplayName == "Ghibli Collection")
        #expect(enAppName == "Ghibli Collection")
        
        // Japanese test
        let jaPath = try #require(appBundle.path(forResource: "ja", ofType: "lproj"))
        let jaBundle = try #require(Bundle(path: jaPath))
        let jaDisplayName = jaBundle.localizedInfoDictionary?["CFBundleDisplayName"] as? String
            ?? NSLocalizedString("CFBundleDisplayName", tableName: "InfoPlist", bundle: jaBundle, comment: "")
        let jaAppName = NSLocalizedString("app_name", bundle: jaBundle, comment: "")
        #expect(jaDisplayName == "ジブリコレクション")
        #expect(jaAppName == "ジブリコレクション")
    }
}
