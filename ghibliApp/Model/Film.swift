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
        
        case bannerImage = "movie_banner"
        
        case releaseYear = "release_date"
        case duration = "running_time"
        case score = "rt_score"
    }
    // MARK: Preview
    // preview용 더미 데이터
    static var example: Film {
        MockGhibliService().fetchPreviewFilm()
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
