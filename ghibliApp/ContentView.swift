//
//  ContentView.swift
//  ghibliApp
//
//  Created by YOON on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    // FilmsViewModel 인스턴스를 상태 변수로 선언합니다.
    // 이 상태변수를 view에서 공유해서 재사용 한다
    @State private var filmsViewModel = FilmsViewModel()

    var body: some View {
        
        
        // TabView는 여러 개의 뷰를 탭 형식으로 전환할 수 있게 해주는 컨테이너 뷰입니다.
        TabView {
            Tab("Movies", systemImage: "movieclapper"){
                FilmsScreen(filmsViewModel: filmsViewModel)
            }
            Tab("Favorites", systemImage: "heart"){
                FavoritesScreen(filmsViewModel: filmsViewModel)
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
