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
    
    var body: some View {
        Text(film.title)
    }
}

#Preview {
    FilmDetailScreen(film: Film.example)
}
