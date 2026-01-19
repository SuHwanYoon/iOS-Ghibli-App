//
//  DefaultGhibliService.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//

import Foundation

// DefaultGhibliService는 GhibliService 프로토콜을 채택한 기본 구현체입니다.
// 일반적으로 상태가 계속변화하지않는 서비스 구현체에는 struct를 사용합니다.
// 상태가 계속 변해야하는 경우에는 class로 구현합니다
struct DefaultGhibliService: GhibliService {
    // fetchFilms 함수는 비동기적으로 영화 데이터를 가져오고
    // Film 타입의 배열을 반환하거나 오류를 던집니다.
     func fetchFilms() async throws -> [Film] {
        // guard문을 사용하여 URL언래핑이 성공하면 할당하고
        // 실패하면 APIError.invaildURL 오류를 던져 조기종료 시킴
        guard let url = URL(string: "https://ghibliapi.vercel.app/films") else {
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
            return try JSONDecoder().decode([Film].self, from: data)
        }catch let error as DecodingError{
            throw APIError.decoding(error)
        }catch let error as URLError {
            throw APIError.networkError(error)
        }
        
    }
    
    
}
