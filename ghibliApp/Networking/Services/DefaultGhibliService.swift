//
//  DefaultGhibliService.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//

import Foundation

// DefaultGhibliService는 GhibliService 프로토콜을 채택한 기본 구현체입니다.
// 어떻게 할지를 구현하는 부분입니다
// 일반적으로 상태가 계속변화하지않는 서비스 구현체에는 struct를 사용합니다.
// struct는 값 타입이고 내부 프로퍼티도 모두 Sendable일 때만 Swift가 안전하다고 판단해 선언을 명시하지 않아도 Sendable로 자동 추론됨
// 상태가 계속 변해야하는 경우에는 class로 구현합니다
struct DefaultGhibliService: GhibliService {
    
    // fetch 제네릭 메서드 구현체
    // T는 Decodable 프로토콜을 준수하는 타입이어야 합니다. <T: Decodable>
    // 이 메서드는 주어진 URLString에서 데이터를 비동기적으로 가져오고
    // 해당 데이터를 T 타입으로 디코딩하여 반환합니다. -> T
    // 하나의 메서드로 파라미터의 타입에따라 다양한 타입을 반환하기 위해서 사용함
    func fetch<T: Decodable>(from URLString: String, type: T.Type) async throws -> T {
        
           // guard문을 사용하여 URL언래핑이 성공하면 할당하고
           // 실패하면 APIError.invaildURL 오류를 던져 조기종료 시킴
           guard let url = URL(string: URLString) else {
               throw APIError.invaildURL
           }
           
           do {
               // 데이터를 URL에서 가져옵니다.
               // (data, response) 튜플로 반환됩니다.
               let (data, response) = try await URLSession.shared.data(from: url)
               // , 를 사용하여 response를 HTTPURLResponse로 먼저 캐스팅하고 (조건1)
               // 캐스팅된 statusCode가 200~299 범위에 있는지 확인합니다.(조건2)
               guard let httpResponse = response as? HTTPURLResponse,
                     (200...299).contains(httpResponse.statusCode) else {
                   throw APIError.invaildResponse
               }
               
               // JSON 데이터를 디코딩하여 films 배열에 저장합니다.
               return try JSONDecoder().decode(type, from: data)
           }catch let error as DecodingError{
               throw APIError.decoding(error)
           }catch let error as URLError {
               throw APIError.networkError(error)
           }
    }
    
    
    // [Film]을 가져오는 프로토콜 메서드 구현체 1
    // fetchFilms 함수는 비동기적으로 영화 데이터를 가져오고
    // Film 타입의 배열을 반환하거나 오류를 던집니다.
     func fetchFilms() async throws -> [Film] {
         
         let url = "https://ghibliapi.vercel.app/films"
         // fetch 제네릭 메서드를 호출하여 [Film].self 타입을 지정하여 호출
         return try await fetch(from: url, type: [Film].self)
         
    }
    
    // Person을 가져오는 프로토콜 메서드의 구현체
    func fetchPerson(from URLString: String) async throws -> Person {
        // fetch 제네릭 메서드를 호출하여 Person.self 타입을 지정하여 호출
        return try await fetch(from: URLString, type: Person.self)
    }
    
}


// 만약 AuthRepositoyrory가 필요하다면 아래와 같이 구현할 수 있습니다.
//class AuthRepository {
//    var token : String?
//    
//    let service: AuthService
//    
//    func refresh(){
//        token = "new_token"
//    }
//}
