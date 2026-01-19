//
//  FilmDetailViewModel.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//

import Foundation
import Observation

class FilmDetailViewModel {
    
    // 반환할 사람(Person) 배열을 담는데 사용할 프로퍼티 선언
    var people: [Person] = []
    
    let service: GhibliService
    // DefaultGhibliService 를 기본값으로 사용하는 이니셜라이저
    init(service: GhibliService = DefaultGhibliService()) {
        self.service = service
    }
    
    
    func fetch(for film: Film) async {
        
        
        
        do {
            //withThrowingTaskGroup 구조는 Task생성과 결과수집이 명시적으로 구분됨
            
            // Film에 등장하는 모든 사람(Person)의 정보를 병렬로 가져오는 로직
            // 각 Person URL마다 네트워크 요청수행
            // withThrowingTaskGroup을 사용하여 병렬로 여러 작업을 수행합니다.
            // ThrowingTaskGroup은 작업 중 하나라도 오류가 발생하면 전체 그룹이 실패하도록 합니다.
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
                    self.people.append(person)
                }
                
            }
        }catch {
            
        }
        
    }
}


import Playgrounds

#Playground {
    let viewModel = FilmDetailViewModel()
    
    // Mock테스트용 서비스사용
    let film = MockGhibliService().fetchPreviewFilm()
    
    await viewModel.fetch(for: film)
    
    
    for person in viewModel.people {
        print(person)
    }
}
