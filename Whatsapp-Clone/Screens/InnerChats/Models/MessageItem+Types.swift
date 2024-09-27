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
}

enum messageDirection {
    case sent,received
    
    static var random : messageDirection {
        return [messageDirection.sent,.received].randomElement() ?? .sent
    }
}
