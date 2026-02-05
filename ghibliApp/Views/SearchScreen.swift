//
//  SearchScreen.swift
//  ghibliApp
//
//  Created by YOON on 2/5/26.
//

import SwiftUI

struct SearchScreen: View {
    
    // 검색어를 바인딩할 상태 변수
    @State private var text: String = ""
    
    var body: some View {
        // navigationStack는 검색창을 제공하기 위해 필요
        NavigationStack{
            Text("Search Screen")
                .searchable(text: $text)
            
        }
    }
}

#Preview {
    SearchScreen()
}
