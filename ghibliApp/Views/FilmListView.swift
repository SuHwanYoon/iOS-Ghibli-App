//
//  FilmListView.swift
//  ghibliApp
//
//  Created by YOON on 1/13/26.
//

import SwiftUI

struct FilmListView: View {
    
    // films: [Film]
    @State private var filmsViewModel = FilmsViewModel()
    
    var body: some View {
        // List는 films 배열의 각 영화를 표시합니다.
        // $0은 각 영화 객체를 나타냅니다.
        // task는 언제 어떤 비통기작업을 실행할지를 지정함
        List(filmsViewModel.films){
            Text($0.title)
        }
        .task {
            await filmsViewModel.fetchFilms()
        }
    }
}

#Preview {
    FilmListView()
}
