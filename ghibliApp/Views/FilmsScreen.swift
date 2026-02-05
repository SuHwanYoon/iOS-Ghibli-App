//
//  FilmsScreen.swift
//  ghibliApp
//
//  Created by YOON on 2/5/26.
//

import SwiftUI

struct FilmsScreen: View {
    // 생명주기가 긴 상위 컨테이너에서 생성한
    // 뷰모델 주입 받음으로써 이 view는
    let filmsViewModel : FilmsViewModel
    
    var body: some View {
        // NavigationStack는 네비게이션 기반의 UI를 구성하는 컨테이너입니다.
        NavigationStack {
            // FilmListView를 불러오면서
            // 상위 컨테이너에서 주입받은 뷰모델을
            // 다시 하위 뷰로 전달해준다
            FilmListView(filmsViewModel: filmsViewModel)
                .navigationTitle("Ghibli Films")
        }
        .task {
            await filmsViewModel.fetch()
        }
    }
}

#Preview {
    FilmsScreen(filmsViewModel : FilmsViewModel(service: MockGhibliService()))
}
