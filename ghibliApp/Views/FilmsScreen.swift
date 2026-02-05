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
        // FilmListView를 불러오면서
        // 상위 컨테이너에서 주입받은 뷰모델을
        // 다시 하위 뷰로 전달해준다
        FilmListView(filmsViewModel: filmsViewModel)
    }
}

#Preview {
    FilmsScreen(filmsViewModel : FilmsViewModel(service: MockGhibliService()))
}
