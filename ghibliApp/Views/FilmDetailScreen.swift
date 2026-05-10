//
//  FilmDetailScreen.swift
//  ghibliApp
//
//  Created by YOON on 1/24/26.
//

import SwiftUI

struct FilmDetailScreen: View {
    // 호출시 받을 film 객체 선언
    let film: Film
    // 호출시 받을 favoritesViewModel 객체 선언
    let favoritesViewModel: FavoritesViewModel
    // 상세페이지에서 임시로 사용할 isFavorite 상태 선언
    var isFavorite: Bool {
        favoritesViewModel.isFavorite(filmID: film.id)
    }
    // view에서 사용할 viewModel 생성 소유
    @State private var viewModel = FilmDetailViewModel()
    
    var body: some View {
        //ScrollView는 스크롤 가능한 컨테이너입니다.
        ScrollView {
            // 배너이미지 + 제목, 등장인물 목록을 수직으로 배치
            VStack(alignment: .leading){
                // FilmImageView를 사용하여 bannerImage표시
                // clipped()로 뷰의 경계를 벗어난 부분을 잘라냄
                // containerRelativeFrame(.horizontal)로 가로 전체 너비 사용
                FilmImageView(urlPath: film.bannerImage)
                    .frame(height: 300)
                    .clipped()
                    .containerRelativeFrame(.horizontal)
                // 배너이미지 하단에 제목, 등장인물 목록을 수직으로 배치
                VStack(alignment: .leading){
                    // 영화 제목 표시
                    Text(film.title)
                    
                    Divider()
                    
                    Text("Characters")
                        .font(.title3)
                    // 상태에 따라 다른 UI를 표시
                    // .loaded 상태일 때는 등장인물 목록을 표시
                    switch viewModel.state {
                    case .idle: EmptyView()
                    case .loading:ProgressView()
                    case .loaded(let people):
                        ForEach(people){ person in
                            Text(person.name)
                            
                        }
                    case .error(let error):
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                // padding으로 뷰의 내부 여백을 추가
                .padding()
            }
        }
        // toolbar는 네비게이션 바에 버튼이나 다른 요소를 추가하는 데 사용됩니다. 여기서는 즐겨찾기 버튼을 추가합니다.
        .toolbar {
            // Heart를 추가하는 Control View
            Button {
                // 즐겨찾기 여부에 따라 영화 항목을 즐겨찾기에 추가하거나 제거
                favoritesViewModel.toggleFavorite(filmID: film.id)
            } label: {
                Image(systemName:
                        // 즐겨찾기 여부에 따라 heart.fill 또는 heart 시스템 이미지를 표시
                      // isFavorite이 true이면 heart.fill, false이면 heart를 표시
                      // foregroundColor는 이미지의 색상을 설정하는데, 즐겨찾기된 항목은 빨간색, 그렇지 않은 항목은 회색으로 표시
                      isFavorite ? "heart.fill" :"heart")
                .foregroundColor(isFavorite ? .red : .gray)
            }
        }
        // task모디파이어가 비동기로 API 가져오는 작업을 수행
        // id: film은 film이 변경될 때마다 task가 다시 실행되도록 함
        .task(id: film) {
            await viewModel.fetch(for: film)
        }
    }
}

#Preview {
    NavigationStack {
        
        // preview에서는 더미 데이터 가져와서 표시중
        FilmDetailScreen(film: Film.example,
                         favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
    }
}
