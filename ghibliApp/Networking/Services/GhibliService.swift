//
//  GhibliService.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//

import Foundation

// protocol 키워드는 인터페이스를 정의하는 데 사용됩니다.
// protocol에 선언된 함수는 해당 프로토콜을 채택한 타입에서
// 외부에서 호출이 가능해야 합니다
// GhibliService 프로토콜은 추상화 계층으로 무엇을 할수있는지만 정의하며
// 여러가지 역할의 메서드들을 정의할수 있습니다
protocol GhibliService {
    // 비동기적으로 영화 데이터의 배열을 가져오는 메서드의 서명을 정의합니다.
    func fetchFilms() async throws -> [Film]
    // 비동기적으로 인물 데이터 객체하나를 가져오는 메서드의 서명을 정의합니다.
    func fetchPerson(from URLString: String) async throws -> Person
}
