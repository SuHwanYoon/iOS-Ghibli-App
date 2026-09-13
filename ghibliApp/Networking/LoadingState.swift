//
//  LoadingState.swift
//  ghibliApp
//
//  Created by YOON on 7/1/26.
//

import Foundation

// LoadingState는 비동기 데이터 로딩의 상태를 나타내는 열거형입니다.
// <T>는 제네릭 타입 매개변수로, 로딩된 데이터의 타입을 나타냅니다. 이 열거형은 네 가지 상태를 가질 수 있습니다:
// Equatable 프로토콜을 채택하여, Equatable타입을 준수하는 타입만 T자리에 넣을수 있도록 제한
// LoadingState자체에 대한 Equatable 준수도 가능하게 합니다. 즉, 두 LoadingState 인스턴스를 비교할 수 있습니다.
enum LoadingState<T: Equatable> : Equatable{
    
    //  idle: 초기 상태를 나타냅니다. 데이터 로딩이 시작되지 않은 상태입니다.
    case idle
    case loading
    case loaded(T)
    case error(String)
    
    // isLoading 프로퍼티는 현재 상태가 로딩 중인지 여부를 반환합니다.
    var isLoading: Bool {
        // Swift에서 if case는 특정 열거형 케이스를 확인하고, 해당 케이스에 연관된 값을 추출할 수 있는 구문입니다.
        if case .loading = self {return true}
        return false
    }
    
    // data 프로퍼티는 현재 상태가 loaded인 경우에만 데이터를 반환합니다. 그렇지 않으면 nil을 반환합니다.
    var data: T? {
        if case .loaded(let data) = self {return data}
        return nil
    }
    
    // error 프로퍼티는 현재 상태가 failed인 경우에만 오류 메시지를 반환합니다. 그렇지 않으면 nil을 반환합니다.
    var error: String? {
        if case .error(let message) = self {return message}
        return nil
    }
}
