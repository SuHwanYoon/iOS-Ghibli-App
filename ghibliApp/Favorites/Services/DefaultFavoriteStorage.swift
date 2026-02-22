//
//  DefaultFavoriteStorage.swift
//  ghibliApp
//
//  Created by YOON on 2/12/26.
//

import Foundation

// FavoriteStorage 프로토콜의 구현체
struct DefaultFavoriteStorage : FavoriteStorage {
    
    // UserDefaults에 저장할 때 사용할 키
    // UserDefaults는 간단한 데이터 저장을 위해 키-값 쌍을 사용하므로
    // 고유한 키를 정의하는 것이 중요합니다
    private let favoritesKey = "GhibliExplorer.FavoriteFilms"
    
    // Set<String>을 반환하는 load 메서드는 UserDefaults에서 즐겨찾기된 영화 ID를 불러오는 역할을 합니다
    func load() -> Set<String> {
        // array 상수에 UserDefaults에서 불러온 문자열 배열을 할당
        // 해당 키에 저장된 값이 없으면 빈 배열을 할당
        // 그런 다음 favoriteIDs 집합을 해당 배열의 요소들로 초기화합니다
        let array = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        return Set(array)
    }
    
    // save는 parameter로 전달된 favoriteIDs 집합을 UserDefaults에 저장
    func save(favoriteIDs: Set<String>) {
        // favoriteIDs 집합을 배열로 변환하여 UserDefaults에 저장
        UserDefaults.standard.set(Array(favoriteIDs), forKey: favoritesKey)
    }
    
}
