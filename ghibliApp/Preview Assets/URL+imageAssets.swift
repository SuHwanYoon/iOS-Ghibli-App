//
//  URL+imageAssets.swift
//  ghibliApp
//
//  Created by YOON on 1/31/26.
//

import UIKit

// 이 익스텐션은 URL 타입에 새로운 기능을 추가합니다.
/// Retrieves (or creates should it be necessary) a temporary image's local URL on cache directory for testing purposes
/// - Parameter named: image name retrieved from asset catalog
/// - Parameter extension: Image type. Defaults to `.jpg` kind
/// - Returns: Resulting URL for named image
///
extension URL {
    static func convertAssetImage(named name: String,
                                  extension: String = "jpg") -> URL? {
        let fileManager = FileManager.default
        
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let url = cacheDirectory.appendingPathComponent("\(name).\(`extension`)")
        
        guard !fileManager.fileExists(atPath: url.path) else {
            return url
        }
        
        guard let image = UIImage(named: name),
              let data = image.jpegData(compressionQuality: 1) else {
            return nil
        }
        
        fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
        return url
    }
}
