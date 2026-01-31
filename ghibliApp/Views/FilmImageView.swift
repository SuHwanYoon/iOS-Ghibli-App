//
//  FilmImageView.swift
//  ghibliApp
//
//  Created by YOON on 1/27/26.
//

import SwiftUI

struct FilmImageView: View {
    
    let url:URL?
    
    init(urlPath: String) {
        self.url = URL(string: urlPath)
    }
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        AsyncImage(url: url){
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
    // 테스트용 로컬 이미지 URL 생성
    // 이미지 이름
//    let name = "posterImage"
//    let url = AssetExtractor().createLocalUrl(forImageNamed: name)

    
// 실제 네트워크 이미지를 테스트하려면 아래 주석을 해제하세요.
//    FilmImageView(urlPath: "https://image.tmdb.org/t/p/w600_and_h900_bestv2/npOnzAbLh6VOIu3naU5QaEcTepo.jpg")
    
    // 로컬 에셋 이미지를 테스트하려면 아래 코드를 사용하세요.
    // Extension의 URL.convertAssetImage 사용
    // 짧게 URL.convertAssetImage(named: "posterImage") 형태로 사용 가능
    FilmImageView(url: URL.convertAssetImage(named: "posterImage"))
        .frame(height: 150)
}


#Preview("banner_image") {
    let name = "bannerImage"
    let url = URL.convertAssetImage(named: name)
//    FilmImageView(urlPath: "https://image.tmdb.org/t/p/w533_and_h300_bestv2/3cyjYtLWCBE1uvWINHFsFnE8LUK.jpg")
    // 로컬 캐시 이미지를 테스트하려면 아래 코드를 사용하세요.
    FilmImageView(url: url)
        .frame(height: 300)
}

