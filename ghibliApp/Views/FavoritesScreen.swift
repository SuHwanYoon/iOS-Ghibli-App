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
    
    var films: [Film] {
        // TODO: get favorite
        // retrieve ids from storage
        // get data for favorite ids from films data
        return []
    }
    
    var body: some View {
        NavigationStack{
            Group{
                if films.isEmpty{
                    ContentUnavailableView("No Favorites yet", systemImage: "heart" )
                }else{
                    FilmListView(films: films)
                }
            }
                .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesScreen(filmsViewModel: FilmsViewModel(service: MockGhibliService()))
}
