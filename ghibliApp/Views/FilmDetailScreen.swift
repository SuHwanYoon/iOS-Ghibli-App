//
//  FilmDetailScreen.swift
//  ghibliApp
//
//  Created by YOON on 1/24/26.
//

import SwiftUI

struct FilmDetailScreen: View {
    
    // 상위 환경에서 전달되는 로케일 환경변수
    @Environment(\.locale) private var locale
    
    // 호출시 받을 film 객체 선언
    let film: Film
    // 호출시 받을 favoritesViewModel 객체 선언
    let favoritesViewModel: FavoritesViewModel
    
    // view에서 사용할 viewModel 생성 소유
    @State private var viewModel = FilmDetailViewModel()
    
    var body: some View {
        //ScrollView는 스크롤 가능한 컨테이너입니다.
        ScrollView {
            // 배너이미지 + 제목, 등장인물 목록을 수직으로 배치
            VStack(alignment: .leading){
                // FilmImageView를 사용하여 bannerImage표시
                // containerRelativeFrame(.horizontal)로 가로 전체 너비 사용 후 높이 지정
                // clipped()로 뷰의 경계를 벗어난 부분을 잘라냄
                FilmImageView(urlPath: film.bannerImage)
                    .containerRelativeFrame(.horizontal)
                    .frame(height: 300)
                    .clipped()
                // 배너이미지 하단에 제목, 등장인물 목록을 수직으로 배치
                VStack(alignment: .leading){
                    // 영화 제목 표시
                    Text(film.title)
                        .font(.title2)
                        .bold()
                    
                    Divider()
                    
                    Text("film_detail_characters_title")
                        .font(.title3)
                    // 상태에 따라 다른 UI를 표시
                    // .loaded 상태일 때는 등장인물 목록을 표시
                    switch viewModel.state {
                    case .idle: EmptyView()
                    case .loading: ProgressView()
                    case .loaded(let people):
                        if people.isEmpty {
                            Text("film_detail_no_characters")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        } else {
                            ForEach(people) { person in
                                Text(person.name)
                            }
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
        .navigationTitle(film.title)
        .navigationBarTitleDisplayMode(.inline)
        // toolbar는 네비게이션 바에 버튼이나 다른 요소를 추가하는 데 사용됩니다. 여기서는 즐겨찾기 버튼을 추가합니다.
        .toolbar {
            FavoriteButton(filmID: film.id , favoritesViewModel: favoritesViewModel)
        }
        // task모디파이어가 비동기로 API 가져오는 작업을 수행
        // id: film은 film이 변경될 때마다 task가 다시 실행되도록 함
        .task(id: film) {
            await viewModel.fetch(for: film)
        }
    }
}



#Preview {
    Group {
        NavigationStack {
            FilmDetailScreen(film: Film.example,
                             favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
        }
        .environment(\.locale, Locale(identifier: "ko"))

        NavigationStack {
            FilmDetailScreen(film: Film.example,
                             favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
        }
        .environment(\.locale, Locale(identifier: "en"))

        NavigationStack {
            FilmDetailScreen(film: Film.example,
                             favoritesViewModel: FavoritesViewModel(service: MockFavoriteStorage()))
        }
        .environment(\.locale, Locale(identifier: "ja"))
    }
}
