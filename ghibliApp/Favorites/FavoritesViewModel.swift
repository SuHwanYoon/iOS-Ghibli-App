//
//  FavoritesViewModel.swift
//  ghibliApp
//
//  Created by YOON on 2/12/26.
//

import Foundation
import Observation

@Observable
class FavoritesViewModel {
    // 즐겨찾기된 영화 ID를 저장하는 집합
    // private(set) 접근 제어자는 외부에서 읽기만 가능하고
    // FavoritesViewModel 내부에서는 쓰기가 가능하도록 설정합니다
    // private(set)을 사용하는 이유는 외부에서 임의로 데이터를 변경하지 못하게 하기 위함입니다
    private(set) var favoriteIDs: Set<String> = []
    
    // FavoriteStorage 프로토콜을 사용하기 위한 프로퍼티 선언
    private let service: FavoriteStorage
    
    // 이 init은 DI(Dependency Injection) 패턴을 사용하여
    // FavoritesViewModel이 생성될 때 외부에서 FavoriteStorage 구현체를 주입
    init(service: FavoriteStorage = DefaultFavoriteStorage()){
        self.service = service
    }
    
    func load() {
        favoriteIDs = service.load()
        // 구현체 load()에서 동작할 코드
        //        let array = UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
        //        favoriteIDs = Set(array)
    }
    
    // save 메서드는 현재 favoriteIDs 집합을 FavoriteStorage 구현체를 통해 저장하는 역할을 합니다
    // 내부에서만 사용되도록 private으로 선언되어 있습니다
    private func save(){
        service.save(favoriteIDs: favoriteIDs)
        // 구현체 save()에서 동작할 코드
        //        UserDefaults.standard.set(Array(favoriteIDs), forKey: favoritesKey)
    }
    
    // 즐겨찾기 토글 메서드
    // favoriteIDs 집합에 filmID가 이미 존재하면 제거하고
    // 존재하지 않으면 추가하는 방식으로 동작
    func toggleFavorite(filmID: String) {
        if favoriteIDs.contains(filmID) {
            favoriteIDs.remove(filmID)
        } else {
            favoriteIDs.insert(filmID)
        }
        save()
    }
    
    // 즐겨찾기 여부를 확인하는 isFavorite 메서드
    func isFavorite(filmID: String) -> Bool {
        favoriteIDs.contains(filmID)
    }
}
