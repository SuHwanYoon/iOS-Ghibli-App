//
//  FilmsViewModel.swift
//  ghibliApp
//
//  Created by YOON on 1/13/26.
//

import Foundation
import Observation

// 로직에서 사용할 LocalizedError를 준수하는 APIError 열거형을 정의합니다.
// deconing(Error) 케이스는 디코딩 오류를 캡처하고
// networkError(Error) 케이스는 네트워크 오류를 캡처합니다.
enum APIError: LocalizedError {
    case invaildURL
    case invaildResponse
    case decoding(Error)
    case networkError(Error)
    
    // errorDescription 프로퍼티를 구현하여 각 오류에 대한 사용자 친화적인 설명을 제공합니다.
    var errorDescription: String? {
        switch self {
        case .invaildURL:
            return "The URL provided was invalid."
        case .invaildResponse:
            return "The server response was invalid."
        case .decoding(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        }
        
    }
}
// 이 ViewModel은 영화 데이터를 가져오고 저장하는 역할을 합니다.
// Observable로 인해 뷰에서 이 ViewModel의 변경되면 자동으로 업데이트됩니다.
@Observable
class FilmsViewModel {
    // loaded 상태는 Film 타입의 배열을 연관값으로 가집니다.
    // Equatable은 동등성비교 프로토콜
    enum State : Equatable  {
        case idle
        case loading
        case loaded([Film])
        case error(String)
    }
    // 현재 ViewModel의 상태를 저장할 프로퍼티
    // Swift에서 모든 저장프로퍼티는 초기화되어있어야 하므로 .idle로 초기화 축약형으로도 가능
    // 초기화방법은 선언시 초기화혹은 init에서 초기화 하기가 있음
    var state: State = State.idle
    
    // films는 영화 데이터를 저장할 초기 배열을 먼저 선언
    // 이 초기배열에 API로부터 가져온 Film 타입의 배열을 저장
    var films: [Film] = []
    
    // fetchFilms함수를 하용하는 공개 비동기 함수 fetch()
    func fetch() async {
        // 중복호출을 방지하기 위해서
        // 현재상태가 idle일때만 실행 그외의 상태는 return으로 종료
        guard self.state == State.idle else { return }
        // 로딩 시작상태로 변경
        self.state = State.loading
        
        do {
            //API호출 하는 메서드실행
            // 호출성공시 호출한 Film형태의 배열 가져옴
            // 상태에 loaded 형태의 상태와 films 배열을 함께 담음
            let films = try await fetchFilms()
            self.state = State.loaded(films)
        }catch let error as APIError {
            // APIError 타입의 오류가 발생하면
            // errorDescription을 사용하여 오류 메시지를 상태에 담음
            self.state = State.error(error.errorDescription ?? "Unknown error")
        }catch {
            // 오류발생시는 error상태로 저장
            self.state = State.error("Unknown error")
        }
    }
    
    // fetchFilms 함수는 비동기적으로 영화 데이터를 가져오고
    // Film 타입의 배열을 반환하거나 오류를 던집니다.
    private func fetchFilms() async throws -> [Film] {
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

