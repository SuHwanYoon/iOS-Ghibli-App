//
//  FilmListView.swift
//  ghibliApp
//
//  Created by YOON on 1/13/26.
//

import SwiftUI

struct FilmListView: View {
    // FilmListView호출시 films 배열을 주입받음
    var films: [Film]
    
    // View의 본문
    var body: some View {
        // List는 films 배열의 각 영화를 표시합니다.
        // NavigationLink를 사용하여 각 영화 항목을 선택할 수 있도록 합니다.
        // task는 언제 어떤 비통기작업을 실행할지를 지정함
        // navigationDestination는 네비게이션 링크를 통해 이동할 대상 뷰를 지정합니다.
        // for Film.self는 Film 타입의 데이터가 들어오면 클로저를 처리할것을 뜻하고
        // film in FilmDetailScreen(film: film)는 선택된 영화를 FilmDetailScreen 뷰에 전달합니다.
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
        
    }
    
    
}





//#Preview {
//    // @State 속성 래퍼와 @Previewable 속성 래퍼를 사용하여
//    // 미리보기에서 FilmsViewModel 인스턴스를 생성합니다.
//    @State @Previewable var viemModel = FilmsViewModel(service: MockGhibliService())
//
//    // 실제 API 호출을 사용하는 미리보기를 원할 경우 아래 주석을 해제하세요.
//    //    @State @Previewable var viemModel = FilmsViewModel(service: DefaultGhibliService())
//    // FilmListView에 viewModel을 주입하여 미리보기를 생성합니다.
//    FilmListView(filmsViewModel: viemModel)
//}
