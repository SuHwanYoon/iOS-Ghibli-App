//
//  FilmDetailViewModel.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//

import Foundation
import Observation

// 상태변경을 View의 SwiftUI에 알리기 위해 Observable프로토콜 채택
@Observable
class FilmDetailViewModel {
    
    // Equatable은 동등성비교 프로토콜
    enum State : Equatable  {
        case idle
        case loading
        case loaded([Person])
        case error(String)
    }
    
    // state를 저장할 프로퍼티 선언 및 초기화
    var state: State = State.idle
    
    
    private let service: GhibliService
    // DefaultGhibliService 를 기본값으로 사용하는 이니셜라이저
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    
    func fetch(for film: Film) async {
        // state가 loading 상태가 아니면 중복호출 방지를 위해 return
        guard state != State.loading else { return }
        // loading상태를 확인했으니 state를 loading상태로 변경
        state = .loading
        
        //fetch에서 병렬로 가져온 여러 Person데이터를 담을 빈 배열 초기화
        var loadedPeople: [Person] = []
        
        do {
            //withThrowingTaskGroup 구조는 Task생성과 결과수집이 명시적으로 구분됨
            
            // Film에 등장하는 모든 사람(Person)의 정보를 병렬로 가져오는 로직
            // 각 Person URL마다 네트워크 요청수행
            // withThrowingTaskGroup을 사용하여 병렬로 여러 작업을 수행합니다.
            // ThrowingTaskGroup은 작업 중 하나라도 오류가 발생하면 전체 그룹이 실패하도록 합니다.
            // 현재 병렬로 처리되고 있기 때문에 순서보장이 안되는 상태
            try await  withThrowingTaskGroup(of: Person.self){ group in
                
                for personInfoURL in film.people {
                    group.addTask{
                        try await self.service.fetchPerson(from: personInfoURL)
                    }
                }
                
                // collect results as they complete
                // 생성된 Task를 가지고 수집하고 결과를 반환하는 로직
                // TaskGroup안의 Task가 끝나는 순서대로 결과를 하나씩 반환하고
                // 잔환한 결과를 self.people 배열에 추가합니다.
                for try await person in group {
                    loadedPeople.append(person)
                }
                
            }
            
            // 모든 Person 데이터를 성공적으로 가져왔으므로 상태를 loaded로 변경하고
            // 가져온 loadedPeople 배열을 상태에 담음
            state = .loaded(loadedPeople)
        }catch let error as APIError {
            // APIError 타입의 오류가 발생하면
            // errorDescription을 사용하여 오류 메시지를 상태에 담음
            self.state = State.error(error.errorDescription ?? "Unknown error")
        }catch {
            // 오류발생시는 error상태로 저장
            self.state = State.error("Unknown error")
        }
        
    }
}


import Playgrounds

#Playground {
    let service = MockGhibliService()
    
    let viewModel = FilmDetailViewModel(service: service)
    
    // Mock테스트용 서비스사용
    let film = service.fetchPreviewFilm()
    
    await viewModel.fetch(for: film)
    // 이 switch문은 viewModel의 상태에 따라 다른 동작을 수행합니다.
    // loaded 상태에서는 가져온 사람들의 정보를 출력합니다.
    switch viewModel.state {
    case .idle:
        print("idle state")
    case .loading:
        print("loading state")
        // 여기서의 let people는 Enum State의 연관값을 언래핑하는 역할
    case .loaded(let people):
         for person in people {
            print(person)
        }
    case .error(let error):
        print(error)
    }
}
