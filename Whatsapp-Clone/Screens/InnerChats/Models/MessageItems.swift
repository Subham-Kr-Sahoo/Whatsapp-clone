//
//  MessageItems.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct MessageItems : Identifiable {
    let id : String
    let text : String
    let ownerUid : String
    var direction : messageDirection {
        return ownerUid == Auth.auth().currentUser?.uid ? .sent : .received
    }
    let type : MessageType
    static let sentplaceholder = MessageItems(id:UUID().uuidString,text: "HOLY MOLY",ownerUid: "1", type: .text)
    static let receiveplaceholder = MessageItems(id:UUID().uuidString,text: "HOLY MOLY received",ownerUid: "2", type: .text)
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
        MessageItems(id:UUID().uuidString,text: "Hii there",ownerUid: "3",type: .text),
        MessageItems(id:UUID().uuidString,text: "Check this Photo",ownerUid: "4",  type: .photo),
        MessageItems(id:UUID().uuidString,text: "Play this Video", ownerUid: "5", type: .video),
        MessageItems(id:UUID().uuidString,text: "", ownerUid: "6", type: .audio)
    ]
}
extension MessageItems {
    init(id: String,dict:[String:Any]){
        self.id = id
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? ""
        self.type = MessageType(type)
        self.ownerUid = dict[.ownerUid] as? String ?? ""
    }
}

extension String {
    static let `type` = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
}
