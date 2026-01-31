//
//  Film.swift
//  ghibliApp
//
//  Created by YOON on 1/13/26.
//

import Foundation

// struct은 값 타입(value type)이며, Codable 프로토콜을 채택하여 JSON 인코딩 및 디코딩이 가능합니다.
// Codable은 Encodable과 Decodable 프로토콜을 모두 포함합니다.

// Identifiable 프로토콜을 채택하여 각 Film 인스턴스가 고유한 식별자를 가질 수 있습니다.
struct Film: Codable, Identifiable , Equatable, Hashable{
    let id: String
    let title: String
    let description: String
    let director: String
    let producer: String
    
    let releaseYear: String
    let score: String
    let duration: String
    
    let image: String
    let bannerImage: String
    
    let people: [String]
    
    // CodingKeys 열거형은 Film 구조체의 프로퍼티와 JSON 키 간의 매핑을 정의합니다.
    // CodingKeys 열거형을 사용하는 이유는 JSON 키가 Swift 프로퍼티 이름과 다를 때 이를 명시적으로 지정하기 위함입니다.
    enum CodingKeys: String, CodingKey {
        case id, title, image, description, director, producer
        , people
        
        
        case releaseYear = "release_date"
        case duration = "running_time"
        case bannerImage = "movie_banner"
        case score = "rt_score"
    }
    // MARK: Preview
    // 로컬 이미지를와 더미 리턴 객체를 사용하는 미리보기용 데이터 생성
    @MainActor
    static var example: Film {
        // preview용 Json 더미 데이터를 쓰는경우
        //MockGhibliService().fetchFilm()
        let bannerULR = URL.convertAssetImage(named: "bannerImage")
        let posterULR = URL.convertAssetImage(named: "posterImage")
        
       return Film(id: "id",
                   title: "My Neighbor Totoro",
                   description: "Two sisters encounter friendly forest spirits in rural Japan.",
                   director: "Hayao Miyazaki",
                   producer: "Toru Hara",
                   releaseYear: "1988",
                   score: "93",
                   duration: "86",
                   image: posterULR?.absoluteString ?? "",
                   bannerImage: bannerULR?.absoluteString ?? "",
                   people: ["https://ghibliapi.vercel.app/people/598f7048-74ff-41e0-92ef-87dc1ad980a9"])
    }
}

import Playgrounds

#Playground {
    let url = URL(string: "https://ghibliapi.vercel.app/films")!
    
    do {
        let (data, response) = try await
        URLSession.shared.data(from: url)
        
        try JSONDecoder().decode([Film].self, from: data)
    }catch{
        print(error)
    }
}
