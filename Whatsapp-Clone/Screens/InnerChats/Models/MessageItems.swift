//
//  MessageItems.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import Foundation
import SwiftUI

struct MessageItems : Identifiable {
    let id = UUID().uuidString
    let text : String
    let direction : messageDirection
    let type : MessageType
    static let sentplaceholder = MessageItems(text: "HOLY MOLY", direction: .sent, type: .text)
    static let receiveplaceholder = MessageItems(text: "HOLY MOLY received", direction: .received, type: .text)
    var alignment : Alignment {
        return direction == .received ? .leading : .trailing
    }
    var horizontalAlignment : HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    var backgroundColor : Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    static let stubMessages : [MessageItems] = [
        MessageItems(text: "Hii there", direction: .sent, type: .text),
        MessageItems(text: "Check this Photo", direction: .received, type: .photo),
        MessageItems(text: "Play this Video", direction: .sent, type: .video)
    ]
}
enum MessageType {
    case text,photo,video
}

enum messageDirection {
    case sent,received
    
    static var random : messageDirection {
        return [messageDirection.sent,.received].randomElement() ?? .sent
    }
}
