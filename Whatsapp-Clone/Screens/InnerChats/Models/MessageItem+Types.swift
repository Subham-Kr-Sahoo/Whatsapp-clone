//
//  MessageItem+Types.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 28/09/24.
//

import Foundation

enum AdminMessageType : String{
    case channelCreation
    case memberAdded
    case memberRemoved
    case memberLeft
    case channelNameChanged
}

enum MessageType {
    case text,photo,video,audio
    
    var title : String {
        switch self {
        case .text:
            return "text"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .audio:
            return "audio"
        }
    }
    
    init(_ stringValue:String){
        switch stringValue {
        case "text":
            self = .text
        case "photo":
            self = .photo
        case "video":
            self = .video
        case "audio":
            self = .audio
        default:
            self = .text
        }
    }
}

enum messageDirection {
    case sent,received
    
    static var random : messageDirection {
        return [messageDirection.sent,.received].randomElement() ?? .sent
    }
}
