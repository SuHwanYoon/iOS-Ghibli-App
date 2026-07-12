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
        // 중복호출을 방지하기 위해서
        // 현재상태가 idle일때만 실행 그외의 상태는 return으로 종료
//        guard !state.isLoading || state.error != nil else { return }
        
        // Task.sleep(for:) 메서드를 사용하여 0.5초 동안 대기합니다. 이 시간 동안 사용자가 계속 입력을 하고 있다면 이전 작업은 취소되고 새로운 작업이 시작됩니다. 이를 통해 불필요한 API 호출을 방지하고, 사용자가 입력을 완료한 후에만 검색을 수행하도록 합니다.
        // !Task.isCancelled를 사용하여 현재 작업이 취소되었는지 확인합니다. 만약 취소되었다면, 이후의 API 호출을 수행하지 않고 함수를 종료합니다.
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        // guard는 조건이 true일 때만 코드 블록을 실행하고, false일 경우에는 else 블록을 실행합니다.
        // !searchTerm.is는 검색어가 비어있지 않은 경우에만 실행검색어가 비어있으면 함수 실행을 종료합니다.
        guard !searchTerm.isEmpty else {
            return
        }
        // 로딩 시작상태로 변경
        self.state = .loading
        
        do {
            //API호출 하는 메서드실행
            // 호출성공시 호출한 Film형태의 배열 가져옴
            // serive를 참조해서 상태에 loaded 형태의 상태와 films 배열을 함께 담음
            let films = try await service.searchFilm(for: searchTerm)
            self.state = .loaded(films)
        }catch let error as APIError {
            // APIError 타입의 오류가 발생하면
            // errorDescription을 사용하여 오류 메시지를 상태에 담음
            self.state = .error(error.errorDescription ?? "Unknown error")
        }catch {
            // 오류발생시는 error상태로 저장
            self.state = .error("Unknown error")
        }
    }
    
}
