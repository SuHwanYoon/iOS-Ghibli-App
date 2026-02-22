//
//  FavoriteStorage.swift
//  ghibliApp
//
//  Created by YOON on 2/12/26.
//

import Foundation

// 추상화를 위한 프로토콜
protocol FavoriteStorage {
    // 조회를 위한 메서드라서 반환값이 있음
    func load() -> Set<String>
    // 저장을 위한 메서드라서 매개변수가 있음
    func save(favoriteIDs: Set<String>)
}
