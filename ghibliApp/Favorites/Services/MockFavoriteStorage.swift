//
//  MockFavoriteStorage.swift
//  ghibliApp
//
//  Created by YOON on 2/22/26.
//

import Foundation

// MockFavoriteStorage는 FavoriteStorage 프로토콜을 채택하여 구현한 구조체입니다.
struct MockFavoriteStorage: FavoriteStorage {
    
    func load() -> Set<String> {
        // 함수바디가 하나의 표현식만 가지고 있는 경우는
        // Swift에서는 단일 표현식 암시적 반환(implicit return)특성으로 return 키워드를 생략할 수 있습니다.
        // 예를들어 return Set() 대신 [""]만 사용해도 됩니다.
        // 단 여러줄이 아닌 한줄로 표현할 수 있는 경우에만 return 키워드를 생략할 수 있습니다.
        // 아래는 명시적으로 모두 표시한 경우
        return Set(["2baf70d1-42bb-4437-b551-e5fed5a87abe"])
    }
    
    func save(favoriteIDs: Set<String>) {
        <#code#>
    }
    
    
}
