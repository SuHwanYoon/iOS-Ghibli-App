//
//  ghibliAppTests.swift
//  ghibliAppTests
//
//  Created by YOON on 1/9/26.
//

import Testing
import Foundation
@testable import ghibliApp

struct ghibliAppTests {
    //actor는 외부에서 접근하는 공유 상태를 안전하게 관리할 수 있도록 도와주는 Swift의 동시성 모델입니다. actor 내부의 상태는 외부에서 직접 접근할 수 없으며, actor 내부에서 정의된 메서드를 통해서만 접근할 수 있습니다. 이를 통해 데이터 경쟁(race condition)과 같은 동시성 문제를 방지할 수 있습니다.
    actor MockGhibliService: GhibliService {
        
        // 샘플 JSON 데이터를 포함하는 파일 이름
//        private struct SampleData: Decodable {
//            let films: [Film]
//            let people: [Person]
//        }
        
        //SampleData.json 파일에서 샘플 데이터를 로드하는 메서드
//        private func loadSampleData() throws -> SampleData {
//            // 번들에서 SampleData.json 파일의 URL을 가져옵니다.
//            guard let url = Bundle.main.url(forResource: "SampleData", withExtension: "json") else {
//                throw APIError.invaildURL
//            }
//            // 파일에서 데이터를 읽고 JSONDecoder를 사용하여 SampleData 타입으로 디코딩합니다.
//            do {
//                let data = try Data(contentsOf: url)
//                return try JSONDecoder().decode(SampleData.self, from: data)
//            }catch let error as DecodingError{
//                throw APIError.decoding(error)
//            } catch {
//                throw APIError.networkError(error)
//            }
//
//        }
        // MARK: - Properties
        // mockFilms는 테스트용으로 사용할 영화 배열입니다.
        // shouldThrowError는 네트워크 오류를 시뮬레이션할지 여부를 결정하는 플래그입니다.
        // fetchDelay는 fetch 메서드 호출 시 지연 시간을 설정하는 데 사용됩니다.
        let mockFilms: [Film]
        let shouldThrowError: Bool
        let fetchDelay: Duration
        
        
        var fetchCallCount = 0 // fetchFilms 메서드가 호출된 횟수를 추적하는 변수입니다.
        var lastSearchTerm: String? // searchFilm 메서드가 마지막으로 호출될 때 사용된 검색어를 저장하는 변수입니다.
        
        // 기본값을 지정한 이유는 테스트에서 모든 매개변수를 항상 지정하지 않아도 되도록 하기 위함입니다. 예를 들어, 단순히 mockFilms만 지정하고 싶을 때, shouldThrowError와 fetchDelay는 기본값으로 설정되어 있어 편리하게 사용할 수 있습니다.
        init(mockFilms: [Film],
             shouldThrowError: Bool = false,
             fetchDelay: Duration = .zero) {
            self.mockFilms = mockFilms
            self.shouldThrowError = shouldThrowError
            self.fetchDelay = fetchDelay
        }
        // MARK: - Protocol comformace
        // 프로토콜의 메서드 구현
        func fetchFilms() async throws -> [Film] {
//            
//            let data = try loadSampleData()
//            
//            return data.films
            //network 오류를 반환하지 않는한 mockFilms 배열을 반환
            //NSError은 NSError를 사용하여 네트워크 오류를 시뮬레이션합니다.
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Mock Error", code: -1, userInfo: nil))
            }
            
            // fetchDelay가 0보다 크면 지정된 시간만큼 대기합니다.
            if fetchDelay > .zero {
                try await Task.sleep(for: fetchDelay)
            }
            return mockFilms
        }
        
        // GibliService의 메서드를 searchFilm 메서드 구현
        // 빈배열을 반환하는 searchFilm 메서드 구현
        func searchFilm(for searchTerm: String) async throws -> [Film] {
//            let allFilms = try await fetchFilms()
//            
//            // 검색어를 대소문자 구분 없이 포함하는 영화들을 필터링하여 반환합니다.
//            return allFilms.filter { film in
//                film.title.localizedCaseInsensitiveContains(searchTerm)
//            }
            
            // fetchCallCount를 증가시키고 lastSearchTerm을 업데이트합니다.
            self.fetchCallCount += 1
            self.lastSearchTerm = searchTerm
            
            // 만약 shouldThrowError가 true이면 APIError.networkError를 던집니다.
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Mock Error", code: -1, userInfo: nil))
            }
            
            if fetchDelay > .zero {
                try await Task.sleep(for: fetchDelay)
            }
            
            // searchTerm이 비어있으면 mockFilms 배열 전체를 반환하고, 그렇지 않으면 검색어를 포함하는 영화만 필터링하여 반환합니다.
            if searchTerm.isEmpty {
                return mockFilms
            }
            // 검색어를 대소문자 구분 없이 포함하는 영화들을 필터링하여 반환합니다.
            return mockFilms.filter {
                // $0는 클로저의 첫 번째 매개변수를 나타내며, 여기서는 Film 객체를 의미합니다. title.localizedCaseInsensitiveContains(searchTerm)는 Film 객체의 title 속성이 searchTerm을 대소문자 구분 없이 포함하는지 확인합니다.
                $0.title.localizedCaseInsensitiveContains(searchTerm)
            }
        }
        
        // 프로토콜의 Person 데이터 가져오는 메서드 구현
        func fetchPerson(from URLString: String) async throws -> Person {
//            let data = try loadSampleData()
//            
//            // 샘플 데이터에서 첫 번째 인물을 반환합니다.
//            return data.people.first!
            
            // dummy Person 데이터를 반환
            return Person(id: "1", name: "Test Person", gender: "Male", age: "30", eyeColor: "Blue", hairColor: "Brown", films: [], species: "", url: URLString)
        }
        
        // MARK: - Preview Helper
        // 미리보기용으로 사용할 수 있는 영화를 가져오는 메서드
//        func fetchPreviewFilm()  -> Film {
//            let data = try! loadSampleData()
//            
//            return data.films.first!
//
//        }

    }

    // MARK: - Test Data
    let mockFilms = [
        Film(id: "1",
             title: "My Neighbor Totoro",
             description: "Two girls move to the country and discover magical creatures.",
             director: "Hayao Miyazaki",
             producer: "Toru Hara",
             releaseYear: "2001",
             score: "93",
             duration: "",
             image: "",
             bannerImage: "",
             people: []),
        
        Film(id: "2",
             title: "Spirited Away",
             description: "A young girl becomes trapped in a mysterious world of spirits.",
             director: "Hayao Miyazaki",
             producer: "Toshio Suzuki",
             releaseYear: "2001",
             score: "97",
             duration: "",
             image: "",
             bannerImage: "",
             people: []),
        
        Film(id: "3",
             title: "Princess Mononoke",
             description: "A young warrior becomes involved in a struggle between forest spirits and humans.",
             director: "Hayao Miyazaki",
             producer: "Toshio Suzuki",
             releaseYear: "2001",
             score: "92",
             duration: "",
             image: "",
             bannerImage: "",
             people: [])
        
    ]
    
    // 이 테스트 함수의 목적은 SearchFilmsViewModel이 생성 직후에 올바른 초기 상태를 가지고 있는지 확인하는 것입니다.
    @MainActor
    @Test func testInitialState() async throws {
        //        1. Mock 서비스를 준비한다.
        //        2. SearchFilmsViewModel을 생성한다.
        //        3. 생성 직후에는 데이터가 없어야 한다.
        //        4. 생성 직후 상태는 반드시 .idle이어야 한다.
        
        let service = MockGhibliService(mockFilms: mockFilms)
        let viewModel = SearchFilmsViewModel(service: service)
        // #expect를 사용하여 viewModel의 state가 .idle인지 확인합니다.
        // #expect의 기능은 조건이 true인지 확인하고, false이면 테스트 실패로 기록합니다.
        // 현재 state안에 data가 nil인지 확인합니다.
        #expect(viewModel.state.data == nil)
        // viewModel의 state가 .idle인지 확인합니다.
        if case .idle = viewModel.state {
            // Test passes
        } else {
            Issue.record("Expected state to be .idle, but found \(viewModel.state)")
        }
    }
    // 이 test함수의 목적은 검색어를 사용하여 fetch 메서드를 호출했을 때, 검색 결과가 올바르게 필터링되는지 확인하는 것입니다.
    @MainActor
    @Test("Search with query filters results")
    // anync를 사용한다는 것은 이 함수가 비동기적으로 실행될 수 있음을 나타냅니다. 즉, 이 함수 내에서 비동기 작업을 수행할 수 있으며, 호출하는 측에서도 await를 사용하여 이 함수를 호출해야 합니다.
    func testSearchWithQueryFiltersResults() async throws {
        // 1. Mock 서비스를 준비한다.
        let service = MockGhibliService(mockFilms: mockFilms)
        // 2. SearchFilmsViewModel을 생성한다.
        let viewModel = SearchFilmsViewModel(service: service)
        // 3. 검색어를 사용하여 fetch 메서드를 호출한다.
        // 여기서 await를 사용하는 이유는 fetch 메서드가 비동기적으로 실행되기 때문입니다. 즉, fetch 메서드는 네트워크 요청을 수행하고 결과를 기다리는 동안 다른 작업을 수행할 수 있도록 설계되어 있습니다. 따라서 이 메서드를 호출할 때는 await를 사용하여 호출이 완료될 때까지 기다립니다.
        await viewModel.fetch(for: "Totoro")
        // 4. 검색 결과가 올바르게 필터링되었는지 확인한다.
        // 검색결과가 1개인지 확인합니다.
        // 검색결과가 "My Neighbor Totoro"인지 확인합니다.
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
    
    // error test case function
    @MainActor
    @Test("Search with query returns error")
    func testSearchWithQueryReturnsError() async throws {
        // 1. Mock 서비스를 준비한다.
        let service = MockGhibliService(mockFilms: mockFilms, shouldThrowError: true)
        // 2. SearchFilmsViewModel을 생성한다.
        let viewModel = SearchFilmsViewModel(service: service)
        // 3. 검색어를 사용하여 fetch 메서드를 호출한다.
        await viewModel.fetch(for: "Totoro")
        // 4. 검색 결과가 error 상태인지 확인한다.
        if case .error(let errorMessage) = viewModel.state {
            #expect(!errorMessage.isEmpty)
        } else {
            Issue.record("Expected state to be .error, but found \(viewModel.state)")
        }
    }
    
    
    // 이 함수가 테스트 하려는 사용자의 동작은 사용자가 검색어를 입력한 후, API 호출이 완료되기 전에 다른 작업을 수행하거나 검색어 입력을 중단하는 것입니다. 이 경우 fetch 메서드는 API 호출 후에 작업이 취소되었음을 감지하고 상태를 업데이트하지 않아야 합니다.
    @MainActor
    @Test("Task cancellation after API call prevents state update")
    func testCancellationAfterAPICall() async throws {
        // 1. Mock 서비스를 준비한다.
        let service = MockGhibliService(mockFilms: mockFilms, fetchDelay: .microseconds(100))
        
        // 2. SearchFilmsViewModel을 생성한다.
        let searchFilmViewModel = SearchFilmsViewModel(service: service)
        
        // 3. 검색어를 사용하여 fetch 메서드를 호출한다.
        // fetch작업은 주어진 검색어를 기반으로 영화 데이터를 가져오는 비동기 작업입니다.
        // 실제 앱에서는 사용자가 검색어를 입력하고, 그에 따라 API 호출이 이루어지는데, 이 과정에서 사용자가 입력을 중단하거나 다른 작업을 수행할 수 있습니다. 따라서 fetch 메서드가 완료되기 전에 작업이 취소될 수 있습니다.
        let task = Task {
            await searchFilmViewModel.fetch(for: "tot")
        }
        
        // 4. fetch 메서드가 완료되기 전에 작업을 취소한다.
        try? await Task.sleep(for: .microseconds(50))
        task.cancel()
        
        // 5. fetch 메서드가 완료될 때까지 기다린다.
        await task.value
        
        // fetchCallCount와 lastSearchTerm을 확인하여 fetch 메서드가 호출되었는지, 그리고 마지막으로 사용된 검색어가 "tot"인지 확인합니다.
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 1)
        
        // lastSearchTerm을 확인하여 fetch 메서드가 호출되었는지, 그리고 마지막으로 사용된 검색어가 "tot"인지 확인합니다.
        let lastSearchTerm = await service.lastSearchTerm
        #expect(lastSearchTerm == "tot")
       
        #expect(searchFilmViewModel.state.error != nil)
        
        
        
    }
}
