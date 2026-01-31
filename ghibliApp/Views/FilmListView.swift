//
//  FilmListView.swift
//  ghibliApp
//
//  Created by YOON on 1/13/26.
//

import SwiftUI

struct FilmListView: View {
    
    // 이러한 형태는 DI가 아니고
    // view가 직접 viewModel을 생성해서 소유하는 형태
    // 외부 주입을 위해서 @State private 먼저 삭제
    var filmsViewModel = FilmsViewModel()
    // View의 본문
    var body: some View {
        // NavigationStack는 네비게이션 기반의 UI를 구성하는 컨테이너입니다.
        NavigationStack {
            // viewModel의 상태에 따라 다른 UI를 표시
            switch filmsViewModel.state {
                // .idle 상태일 때는 "No Films yet"라는 텍스트를 표시하고
                // .task 수식어를 사용하여 fetch() 메서드를 호출하여 영화 데이터를 가져옵니다.
            case .idle:
                Text("No Films yet")
                
                // .loading 상태일 때는 ProgressView를 표시하여 로딩 중임을 나타냅니다.
            case .loading:
                ProgressView()
                // .loaded 상태일 때는 films 배열을 사용하여 영화 목록을 표시합니다.
                // List는 films 배열의 각 영화를 표시합니다.
                // NavigationLink를 사용하여 각 영화 항목을 선택할 수 있도록 합니다.
                // task는 언제 어떤 비통기작업을 실행할지를 지정함
                // navigationDestination는 네비게이션 링크를 통해 이동할 대상 뷰를 지정합니다.
                // for Film.self는 Film 타입의 데이터가 들어오면 클로저를 처리할것을 뜻하고
                // film in FilmDetailScreen(film: film)는 선택된 영화를 FilmDetailScreen 뷰에 전달합니다.
            case .loaded(let films):
                List(films){ film in
                    NavigationLink(value: film){
                        HStack{
                            FilmImageView(urlPath: film.image)
                                .frame(width: 100, height: 150)
                            Text(film.title)
                        }
                        
                    }
                }
                .navigationDestination(for: Film.self){
                    film in FilmDetailScreen(film: film)
                }
                // .error 상태일 때는 오류 메시지를 빨간색 텍스트로 표시합니다.
            case .error(let error):
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .task {
            await filmsViewModel.fetch()
        }
    }
    
    
}


#Preview {
    // @State 속성 래퍼와 @Previewable 속성 래퍼를 사용하여
    // 미리보기에서 FilmsViewModel 인스턴스를 생성합니다.
    @State @Previewable var viemModel = FilmsViewModel(service: MockGhibliService())
//    @State @Previewable var viemModel = FilmsViewModel(service: DefalultGhibliService())
    // FilmListView에 viewModel을 주입하여 미리보기를 생성합니다.
    FilmListView(filmsViewModel: viemModel)
}
