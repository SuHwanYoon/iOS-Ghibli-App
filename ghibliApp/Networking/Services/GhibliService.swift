//
//  GhibliService.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//

import Foundation

// protocol 키워드는 인터페이스를 정의하는 데 사용됩니다.
// protocol에 선언된 함수는 해당 프로토콜을 채택한 타입에서
// 외부에서 호출이 가능해야 하며 반드시 구현되어야 합니다.
// GhibliService 프로토콜은 추상화 계층으로 무엇을 할수있는지만 정의하며
// 여러가지 역할의 메서드들을 정의할수 있습니다
// 이 메서드들은 메서드 요구사항 Method Requirements라고 부릅니다.
// Sendable은 동시성 환경에서 안전하게 전달될 수 있음을 선언하는 프로토콜입니다.
protocol GhibliService : Sendable{
    // 비동기적으로 영화 데이터의 배열을 가져오는 메서드의 서명을 정의합니다.
    func fetchFilms() async throws -> [Film]
    // 비동기적으로 인물 데이터 객체하나를 가져오는 메서드의 서명을 정의합니다.
    func fetchPerson(from URLString: String) async throws -> Person
    // 검색어를 매개변수로 받아 해당 검색어와 일치하는 영화를 반환하는 메서드의 서명을 정의합니다.
    // for는 외부 매개변수의 이름으로 외부에서 호출할 때 사용되는 이름입니다. searchTerm은 내부 매개변수의 이름으로 함수 내부에서 사용됩니다.
    // asnync는 비동기적으로 실행되는 함수임을 나타내며, throws는 이 함수가 오류를 던질 수 있음을 나타냅니다. 반환 타입은 [Film]으로, 검색 결과로 영화 객체의 배열을 반환할 것으로 예상됩니다.
    // throws는 이 함수가 오류를 던질 수 있음을 나타냅니다.
    // 호출하는 측에서는 반드시 try를 사용해야 하며,
    // 필요에 따라 do-catch로 오류를 처리하거나 상위 호출자에게 전달할 수 있습니다.
    func searchFilm(for searchTerm: String) async throws -> [Film]
    
}
