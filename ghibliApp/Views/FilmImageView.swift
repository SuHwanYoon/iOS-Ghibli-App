//
//  FilmImageView.swift
//  ghibliApp
//
//  Created by YOON on 1/27/26.
//

import SwiftUI

struct FilmImageView: View {
    
    let urlPath: String
    
    var body: some View {
        AsyncImage(url: URL(string: urlPath)){
            phase in
            switch phase {
            case .empty:
                Color.gray.opacity(0.1)
                    .overlay(
                        ProgressView()
                            .controlSize(.large)
                    )
                // 성공상태의 경우 이미지를 리사이즈 가능하고 채우기 모드로 표시
            case .success(let image):
                image.resizable().scaledToFill()
            case .failure(let error):
                Text("Failed to load image: \(error.localizedDescription)")
                    .foregroundColor(.red)
            @unknown default:
                fatalError()
            }
        }
        
        
    }
}

#Preview("poster_image") {
    FilmImageView(urlPath: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg")
        .frame(height: 150)
}


#Preview("banner_image") {
    FilmImageView(urlPath: "https://image.tmdb.org/t/p/w533_and_h300_bestv2/3cyjYtLWCBE1uvWINHFsFnE8LUK.jpg")
        .frame(height: 300)
}
