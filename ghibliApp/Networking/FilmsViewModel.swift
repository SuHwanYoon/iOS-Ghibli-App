//
//  FilmsViewModel.swift
//  ghibliApp
//
//  Created by YOON on 1/13/26.
//

import Foundation
import Observation

// 이 ViewModel은 영화 데이터를 가져오고 저장하는 역할을 합니다.
// Observable로 인해 뷰에서 이 ViewModel의 변경되면 자동으로 업데이트됩니다.
@Observable
class FilmsViewModel {
    
    // films는 영화 데이터를 저장할 초기 배열입니다.
    // 이 초기배열에 API로부터 가져온 Film 타입의 배열을 저장
    var films: [Film] = []
    
    // fetchFilms 함수는 비동기적으로 영화 데이터를 가져오는 메서드입니다.
    func fetchFilms() async {
        
        let url = URL(string: "https://ghibliapi.vercel.app/films")!
        
        do {
            // 데이터를 URL에서 가져옵니다.
            let (data, response) = try await URLSession.shared.data(from: url)

            // JSON 데이터를 디코딩하여 films 배열에 저장합니다.
            films = try JSONDecoder().decode([Film].self, from: data)
        }catch{
            print(error)
        }
        
    }
}
