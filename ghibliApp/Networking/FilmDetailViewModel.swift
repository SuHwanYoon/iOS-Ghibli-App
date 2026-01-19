//
//  FilmDetailViewModel.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//

import Foundation
import Observation

class FilmDetailViewModel {
    
    var people: [Person] = []
    
    let service: GhibliService
    // DefaultGhibliService 를 기본값으로 사용하는 이니셜라이저
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
}
