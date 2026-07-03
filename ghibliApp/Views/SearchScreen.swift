//
//  SearchScreen.swift
//  ghibliApp
//
//  Created by YOON on 2/5/26.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var text: String = ""
    // 검색어를 바인딩할 상태 변수
    @State private var searchViewModel :SearchFilmsViewModel
    // 호출시 받을 favoritesViewModel 객체 선언
    let favoritesViewModel: FavoritesViewModel
    
    // SearchScreen을 호출할때 생성되는 이니셜라이저
    // GhibliService 타입(프로토콜)의 구현체를 주입한다
    // 직접넘기는 구현체가없을경우는 기본값 구현체가 주입된다
    init(favoriteViewModel: FavoritesViewModel,
         service: GhibliService = DefaultGhibliService()) {
        self.favoritesViewModel = favoriteViewModel
        self.searchViewModel = SearchFilmsViewModel(service: service)
    }
    
    var body: some View {
        // navigationStack는 검색창을 제공하기 위해 필요
        // searchable modifier는 검색창을 제공하며, text 바인딩을 통해 검색어를 관리합니다.
        // task modifier는 검색어가 변경될 때마다 비동기 작업을 수행할 수 있게 해줍니다. 여기서는 검색어를 기반으로 데이터를 가져오는 작업을 수행할 수 있습니다.
        // switch searchViewModel.state는 검색 상태에 따라 다른 UI를 표시합니다. idle 상태에서는 "Show search here" 텍스트를 표시하고, loading 상태에서는 ProgressView를 표시하며, error 상태에서는 오류 메시지를 표시하고, loaded 상태에서는 FilmListView를 표시합니다.
        NavigationStack{
            VStack{
                switch searchViewModel.state {
                case .idle:
                    Text("Show search here")
                case .loading:
                    ProgressView()
                case .error(let error):
                    Text(error)
                case .loaded(let films):
                    FilmListView(films: films, favoritesViewModel: favoritesViewModel)
                    
                }
            }
            .searchable(text: $text)
            .task(id: text){
                // Task.sleep(for:) 메서드를 사용하여 0.5초 동안 대기합니다. 이 시간 동안 사용자가 계속 입력을 하고 있다면 이전 작업은 취소되고 새로운 작업이 시작됩니다. 이를 통해 불필요한 API 호출을 방지하고, 사용자가 입력을 완료한 후에만 검색을 수행하도록 합니다.
                // !Task.isCancelled를 사용하여 현재 작업이 취소되었는지 확인합니다. 만약 취소되었다면, 이후의 API 호출을 수행하지 않고 함수를 종료합니다.
                try? await Task.sleep(for: .milliseconds(500))
                guard !Task.isCancelled else { return }
                // await self.searchViewModel.fetch(for: text) 메서드를 호출하여 검색어에 해당하는 영화를 가져옵니다. 이 메서드는 비동기적으로 실행되며, 검색 결과가 로드되면 searchViewModel의 상태가 업데이트되어 UI가 자동으로 갱신됩니다.
                await self.searchViewModel.fetch(for: text)
            }
            
        }
    }
}

#Preview {
    // 즉 현재 Preview에서는
    //    * FavoritesViewModel → MockFavoriteStorage 사용
    //    * SearchFilmsViewModel → DefaultGhibliService 사용
    SearchScreen(favoriteViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
}
