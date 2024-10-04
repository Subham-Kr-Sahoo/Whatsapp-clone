//
//  PhotoPickerItem+Extension.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 05/10/24.
//

import Foundation
import PhotosUI
import SwiftUI


extension PhotosPickerItem {
    var isVideo : Bool {
        let videoUTTtypes : [UTType] = [.avi,.video,.mpeg2Video,.movie,.quickTimeMovie,.audiovisualContent,.mpeg,.appleProtectedMPEG4Video,.mpeg4Movie]
        
        return videoUTTtypes.contains(where:supportedContentTypes.contains)
    }
}


struct MediaAttachment : Identifiable {
    let id : String
    let type : mediaAttachmentType
    
    var thumbNail: UIImage {
        switch type {
        case .photo(let thumbNail):
            return thumbNail
        case .video(let thumbNail, _):
            return thumbNail
        case .audio:
            return UIImage()
        }
    }
}

enum mediaAttachmentType : Equatable {
    case photo(_ thumbNail : UIImage)
    case video(_ thumbNail : UIImage, _ url : URL)
    case audio
    
    static func == (lhs: mediaAttachmentType , rhs: mediaAttachmentType) -> Bool {
        switch (lhs, rhs) {
            case (.photo, .photo): return true
            case (.video, .video): return true
            case (.audio, .audio): return true
            default: return false
        }
    }
}
