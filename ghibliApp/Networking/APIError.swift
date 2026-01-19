//
//  APIError.swift
//  ghibliApp
//
//  Created by YOON on 1/19/26.
//


import Foundation

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
