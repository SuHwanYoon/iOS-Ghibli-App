//
//  MockGhibliService.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//

import Foundation

// MockGhibliService는 GhibliService 프로토콜을 채택한
// 목업(테스트용) 구현체입니다.
// 실제 네트워크 요청을 수행하지 않고
// 미리 정의된 데이터를 반환하는 데 사용됩니다.
struct MockGhibliService: GhibliService {
    
    // 샘플 JSON 데이터를 포함하는 파일 이름
    private struct SampleData: Decodable {
        let films: [Film]
        let people: [Person]
    }
    
    //SampleData.json 파일에서 샘플 데이터를 로드하는 메서드
    private func loadSampleData() throws -> SampleData {
        // 번들에서 SampleData.json 파일의 URL을 가져옵니다.
        guard let url = Bundle.main.url(forResource: "SampleData", withExtension: "json") else {
            throw APIError.invaildURL
        }
        // 파일에서 데이터를 읽고 JSONDecoder를 사용하여 SampleData 타입으로 디코딩합니다.
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(SampleData.self, from: data)
        }catch let error as DecodingError{
            throw APIError.decoding(error)
        } catch {
            throw APIError.networkError(error)
        }

    }
    
    
    // MARK: - Protocol comformace
    // 프로토콜의 메서드 구현
    func fetchFilms() async throws -> [Film] {
        
        let data = try loadSampleData()
        
        return data.films
    }
    
    // 프로토콜의 Person 데이터 가져오는 메서드 구현
    func fetchPerson(from URLString: String) async throws -> Person {
        let data = try loadSampleData()
        
        // 샘플 데이터에서 첫 번째 인물을 반환합니다.
        return data.people.first!

    }
    
    // MARK: - Preview Helper
    // 미리보기용으로 사용할 수 있는 영화를 가져오는 메서드
    func fetchPreviewFilm()  -> Film {
        let data = try! loadSampleData()
        
        return data.films.first!

    }

}
