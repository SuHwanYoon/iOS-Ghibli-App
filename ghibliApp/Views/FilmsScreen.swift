//
//  FilmsScreen.swift
//  ghibliApp
//
//  Created by YOON on 2/5/26.
//

import SwiftUI

// FilmsScreen은 영화 목록을 표시하는 화면입니다. 이 화면은 FilmsViewModel과 FavoritesViewModel을 주입받아 사용합니다.
// viewModel의 상태에 따라 다른 UI를 표시하는데, .idle, .loading, .loaded, .error 상태에 따라 각각 다른 뷰를 보여줍니다.
struct FilmsScreen: View {
    // 생명주기가 긴 상위 컨테이너에서 생성한
    // 뷰모델 주입 받음으로써 이 view는 ViewModel을 재사용
    let filmsViewModel : FilmsViewModel
    let favoritesViewModel : FavoritesViewModel
    
    // 앱 언어 설정 관찰 및 실시간 언어 번들 기반 타이틀 로드
    @AppStorage("appLanguage") private var selectedLanguage: String = AppLanguage.system.rawValue

    private var currentAppLanguage: AppLanguage {
        AppLanguage(rawValue: selectedLanguage) ?? .system
    }

    // 선택된 언어 번들에서 직접 'films_navigation_title' 번역 문자열 로드
    private var navigationTitleText: String {
        currentAppLanguage.localizedString(for: "films_navigation_title")
    }

    var body: some View {
        // NavigationStack는 네비게이션 기반의 UI를 구성하는 컨테이너입니다.
        // Group는 여러 뷰를 하나의 단위로 묶어주는 컨테이너입니다.
        NavigationStack {
            
            Group{
                // viewModel의 상태에 따라 다른 UI를 표시
                switch filmsViewModel.state {
                    // .idle 상태일 때는 "No Films yet"라는 텍스트를 표시하고
                    // .task 수식어를 사용하여 fetch() 메서드를 호출하여 영화 데이터를 가져옵니다.
                case .idle:
                    Text("films_empty_state")
                    
                    // .loading 상태일 때는 ProgressView를 표시하여 로딩 중임을 나타냅니다.
                case .loading:
                    ProgressView()
                    // .loaded 때는 films 배열을 사용하여 영화 목록을 표시합니다.
                    // favoritesViewModel을 FilmListView에 전달하여 즐겨찾기 기능을 사용할 수 있도록 합니다.
                    // FilmListView는 영화 목록을 표시하는 커스텀 뷰입니다.
                case .loaded(let films):
                    FilmListView(films: films,
                    favoritesViewModel: favoritesViewModel)
                    
                    // .error 상태일 때는 오류 메시지를 빨간색 텍스트로 표시합니다.
                case .error(let error):
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle(navigationTitleText)
        }
        // 언어 변경 시 NavigationStack의 UINavigationBar 타이틀 캐시를 새로고침하도록 id 부여
        .id(selectedLanguage)
    }
}

#Preview {
    FilmsScreen(filmsViewModel : FilmsViewModel(service: MockGhibliService()),
                favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
}
