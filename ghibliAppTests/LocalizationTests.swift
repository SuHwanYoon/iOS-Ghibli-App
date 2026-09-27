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
        #expect(languages.count == 3)
        
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

    @Test("String Catalog provides valid translations for each language")
    func testStringCatalogTranslations() throws {
        let appBundle = Bundle(for: FilmDetailViewModel.self)
        
        // Korean bundle test
        let koPath = try #require(appBundle.path(forResource: "ko", ofType: "lproj"))
        let koBundle = try #require(Bundle(path: koPath))
        let koCharacters = NSLocalizedString("film_detail_characters_title", bundle: koBundle, comment: "")
        let koEmpty = NSLocalizedString("film_detail_no_characters", bundle: koBundle, comment: "")
        let koTabMovies = NSLocalizedString("tab_movies", bundle: koBundle, comment: "")
        #expect(koCharacters == "등장인물")
        #expect(koEmpty == "등장인물 정보가 없습니다.")
        #expect(koTabMovies == "영화")
        
        // English bundle test
        let enPath = try #require(appBundle.path(forResource: "en", ofType: "lproj"))
        let enBundle = try #require(Bundle(path: enPath))
        let enCharacters = NSLocalizedString("film_detail_characters_title", bundle: enBundle, comment: "")
        let enEmpty = NSLocalizedString("film_detail_no_characters", bundle: enBundle, comment: "")
        let enTabMovies = NSLocalizedString("tab_movies", bundle: enBundle, comment: "")
        #expect(enCharacters == "Characters")
        #expect(enEmpty == "No character information available.")
        #expect(enTabMovies == "Movies")
        
        // Japanese bundle test
        let jaPath = try #require(appBundle.path(forResource: "ja", ofType: "lproj"))
        let jaBundle = try #require(Bundle(path: jaPath))
        let jaCharacters = NSLocalizedString("film_detail_characters_title", bundle: jaBundle, comment: "")
        let jaEmpty = NSLocalizedString("film_detail_no_characters", bundle: jaBundle, comment: "")
        let jaTabMovies = NSLocalizedString("tab_movies", bundle: jaBundle, comment: "")
        #expect(jaCharacters == "登場人物")
        #expect(jaEmpty == "登場人物の情報がありません。")
        #expect(jaTabMovies == "映画")
    }
}
