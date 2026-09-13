//
//  SearchFilmsViewModel.swift
//  ghibliApp
//
//  Created by YOON on 7/1/26.
//

import Foundation
import Observation
    
@Observable
class SearchFilmsViewModel {
    
    // lastSearchTerm 프로퍼티를 선언하고 초기값을 빈 문자열로 설정합니다. 이 프로퍼티는 마지막으로 검색된 영화 제목을 저장하는 데 사용됩니다.
    private var currentSearchTerm: String = ""
    // state 프로퍼티를 선언하고 초기값을 .idle로 설정합니다. 이 프로퍼티는 현재 로딩 상태를 나타냅니다.
    // state는 LoadingState<[Film]> 타입으로, 로딩 상태와 함께 로드된 영화 데이터를 저장할 수 있습니다.
    var state: LoadingState<[Film]> = .idle
    
    //GhibliService 프로퍼티 선언
    private let service: GhibliService
    // 영화 데이터를 저장할 films 배열 선언
//    var films: [Film] = []

    // Initializer Injection DI 패턴
    // viewModel이 생성될 때 init에서 외부서비를 객체를  주입받아 service 프로퍼티에 할당
    // 생성시 service주입이 없으면 DefaultGhibliService()를 기본값으로 사용
    // 있으면 주입받은 service를 사용
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    
    
    // fetchFilms함수를 하용하는 공개 비동기 함수 fetch()
    // 이 함수는 주어진 검색어(searchTerm)를 기반으로 영화 데이터를 가져오는 역할을 하는데
    // 동작의 흐름은 다음과 같습니다.
    // 일단 검색어가 비어있지 않은지 확인하고, 로딩 상태로 전환한 후
    // GhibliService를 통해 영화 데이터를 가져옵니다. 성공하면 상태를 .loaded로 변경하고, 실패하면 상태를 .error로 변경합니다.
    func fetch(for searchTerm: String) async {
        self.currentSearchTerm = searchTerm
        
        guard !searchTerm.isEmpty else {
            state = .idle
            return
        }
        
        self.state = .loading
        
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        
        do {
            //API호출 하는 메서드실행
            // 호출성공시 호출한 Film형태의 배열 가져옴
            // serive를 참조해서 상태에 loaded 형태의 상태와 films 배열을 함께 담음
            let films = try await service.searchFilm(for: searchTerm)
            self.state = .loaded(films)
        
        }catch {
            setError(error, for: searchTerm)
        }
    }
    
    
    func setError(_ error: Error, for searchTerm: String) {
        
        guard currentSearchTerm == searchTerm else {
            return
        }
        
        if let apiError = error as? APIError {
         self.state = .error(apiError.errorDescription ?? "Unknown error")
        }else {
            self.state = .error("Unknown error")
        }
        
    }
}
