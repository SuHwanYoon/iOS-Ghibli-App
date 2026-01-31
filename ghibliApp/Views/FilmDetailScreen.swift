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
        // task모디파이어가 비동기로 API 가져오는 작업을 수행
        // id: film은 film이 변경될 때마다 task가 다시 실행되도록 함
        .task(id: film) {
            await viewModel.fetch(for: film)
        }
    }
}

#Preview {
    // preview에서는 더미 데이터 가져와서 표시중
    FilmDetailScreen(film: Film.example)
}
