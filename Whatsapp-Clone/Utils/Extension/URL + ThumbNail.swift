//
//  URL + ThumbNail.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 05/10/24.
//

import Foundation
import UIKit
import AVFoundation

extension URL {
    static var stubUrl : URL {
        return URL(string: "https://www.youtube.com/")!
    }
    func generateThumbnail() async throws -> UIImage? {
        let asset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        
        return try await withCheckedThrowingContinuation {continuation in
            imageGenerator.generateCGImageAsynchronously(for: time){cgImage,_ ,error in
                if let cgImage = cgImage {
                    let thumbNailImage = UIImage(cgImage: cgImage)
                    continuation.resume(returning: thumbNailImage)
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "", code: 0, userInfo: nil))
                }
            }
        }
    }
}
