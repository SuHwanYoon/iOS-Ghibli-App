//
//  FavoritesScreen.swift
//  ghibliApp
//
//  Created by YOON on 2/5/26.
//

import SwiftUI

struct FavoritesScreen: View {
    // 상위컨테이너에서 생성한 뷰모델 주입 받음으로써 이 view는
    // 생명주기가 긴 뷰모델을 재사용 할 수 있음
    let filmsViewModel : FilmsViewModel
    let favoritesViewModel : FavoritesViewModel
    
    var films: [Film] {
        // favoritesViewModel의 favoriteIDs 배열에서 현재 즐겨찾기된 영화의 ID를 가져옵니다. 그런 다음, filmsViewModel의 films 배열에서 이 ID를 포함하는 영화만 필터링하여 반환합니다.
        // $0는 클로저에서 사용되는 암시적 매개변수로, 현재 처리 중인 요소를 나타냅니다. 여기서는 filmsViewModel.films 배열의 각 요소를 나타냅니다.
        // 즉 $0는 film을 나타내며, favorites.contains($0.id)는 현재 film의 ID가 즐겨찾기된 영화의 ID 목록에 포함되어 있는지를 확인하는 조건입니다.
        let favorites = favoritesViewModel.favoriteIDs
        switch filmsViewModel.state {
            case .loaded(let films):
                return films.filter{favorites.contains($0.id)}
            default: return []
        }
        
        
    }
    
    var body: some View {
        NavigationStack{
            Group{
                if films.isEmpty{
                    ContentUnavailableView("No Favorites yet", systemImage: "heart" )
                }else{
                    FilmListView(films: films,
                                 favoritesViewModel: favoritesViewModel)
                }
                
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesScreen(filmsViewModel: FilmsViewModel.example,
                    favoritesViewModel: FavoritesViewModel.example)
}
