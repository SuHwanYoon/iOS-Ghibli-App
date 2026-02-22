//
//  ContentView.swift
//  ghibliApp
//
//  Created by YOON on 1/9/26.
//

import SwiftUI

// ContentView는 앱의 주요 사용자 인터페이스를 구성하는 뷰입니다. 이 뷰는 여러 개의 탭을 포함하는 TabView로 구성되어 있습니다.
// ContentView는 앱의 진입점으로 앱 시작시 처음으로 보여지는 화면입니다.
struct ContentView: View {
    // FilmsViewModel 인스턴스를 상태 변수로 선언합니다.
    // 이 상태변수를 view에서 공유해서 재사용 한다
    @State private var filmsViewModel = FilmsViewModel()
    // FavoriteViewModel 인스턴스도 상태 변수로 선언합니다.
    @State private var favoritesViewModel = FavoritesViewModel()

    var body: some View {
        
        
        // TabView는 여러 개의 뷰를 탭 형식으로 전환할 수 있게 해주는 컨테이너 뷰입니다.
        TabView {
            Tab("Movies", systemImage: "movieclapper"){
                FilmsScreen(filmsViewModel: filmsViewModel,
                            favoritesViewModel: favoritesViewModel)
            }
            Tab("Favorites", systemImage: "heart"){
                FavoritesScreen(filmsViewModel: filmsViewModel,
                favoritesViewModel: favoritesViewModel)
            }
            Tab("Settings", systemImage: "gear"){
                SettingScreen()
            }
            // role 속성은 탭의 역할을 지정하는 데 사용됩니다. .search 역할은 이 탭이 검색 기능과 관련이 있음을 나타냅니다.
            Tab(role: .search){
                 SearchScreen()
            }
        }
    }
}

#Preview {
    ContentView()
}
