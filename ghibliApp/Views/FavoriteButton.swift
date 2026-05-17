//
//  FavoriteButton.swift
//  ghibliApp
//
//  Created by YOON on 5/17/26.
//


import SwiftUI
// :View는 프로토콜을 채택하여 SwiftUI에서 사용할 수 있는 뷰임을 나타냅니다.
struct FavoriteButton: View {
    //body 바깥쪽은 저장프로퍼티, 상태선언, 함수func, 계산프로퍼티, viewModel선언 등으로 구성됩니다.
    
    // 호출시 받을 film 객체 선언
    let filmID: String
    // 호출시 받을 favoritesViewModel 객체 선언
    let favoritesViewModel: FavoritesViewModel
    // 상세페이지에서 임시로 사용할 isFavorite 상태 선언
    var isFavorite: Bool {
        favoritesViewModel.isFavorite(filmID: filmID)
    }
    // body안은 UI선언 , 단순계산 정의하는 부분입니다.
    var body: some View {
        // Heart를 추가하는 Control View
        Button {
            // 즐겨찾기 여부에 따라 영화 항목을 즐겨찾기에 추가하거나 제거
            favoritesViewModel.toggleFavorite(filmID: filmID)
        } label: {
            Image(systemName:
                    // 즐겨찾기 여부에 따라 heart.fill 또는 heart 시스템 이미지를 표시
                  // isFavorite이 true이면 heart.fill, false이면 heart를 표시
                  // foregroundColor는 이미지의 색상을 설정하는데, 즐겨찾기된 항목은 빨간색, 그렇지 않은 항목은 회색으로 표시
                  isFavorite ? "heart.fill" :"heart")
            .foregroundColor(isFavorite ? .red : .gray)
        }
        
        
    }
    
}
