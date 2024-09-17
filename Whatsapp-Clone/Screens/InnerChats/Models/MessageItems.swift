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
    static let sentplaceholder = MessageItems(text: "HOLY MOLY", direction: .sent)
    static let receiveplaceholder = MessageItems(text: "HOLY MOLY received", direction: .received)
    var alignment : Alignment {
        return direction == .received ? .leading : .trailing
    }
    var horizontalAlignment : HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    var backgroundColor : Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
}

enum messageDirection {
    case sent,received
    
    static var random : messageDirection {
        return [messageDirection.sent,.received].randomElement() ?? .sent
    }
}
