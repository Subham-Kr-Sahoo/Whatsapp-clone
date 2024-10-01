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
    let groupChat : Bool
    let text : String
    let ownerUid : String
    var direction : messageDirection {
        return ownerUid == Auth.auth().currentUser?.uid ? .sent : .received
    }
    var sender : UserItems?
    let type : MessageType
    let timeStamp : Date
    static let sentplaceholder = MessageItems(id:UUID().uuidString, groupChat: true,text: "HOLY MOLY",ownerUid: "1", type: .text,timeStamp: Date())
    static let receiveplaceholder = MessageItems(id:UUID().uuidString, groupChat: false,text: "HOLY MOLY received",ownerUid: "2", type: .text,timeStamp: Date())
    var alignment : Alignment {
        return direction == .received ? .leading : .trailing
    }
    var horizontalAlignment : HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    var backgroundColor : Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    var showGroupPartnerInfo : Bool {
        return groupChat && direction == .received
    }
    private let horizontalPadding : CGFloat = 25
    
    var leadingPaddings : CGFloat {
        return direction == .received ? 0 : horizontalPadding
    }
    
    var trailingPaddings : CGFloat {
        return direction == .received ? horizontalPadding : 0
    }
    
    static let stubMessages : [MessageItems] = [
        MessageItems(id:UUID().uuidString, groupChat: true,text: "Hii there",ownerUid: "3",type: .text,timeStamp: Date()),
        MessageItems(id:UUID().uuidString, groupChat: false,text: "Check this Photo",ownerUid: "4",  type: .photo,timeStamp: Date()),
        MessageItems(id:UUID().uuidString, groupChat: true,text: "Play this Video", ownerUid: "5", type: .video,timeStamp: Date()),
        MessageItems(id:UUID().uuidString, groupChat: false,text: "", ownerUid: "6", type: .audio,timeStamp: Date())
    ]
}
extension MessageItems {
    init(id: String,groupChat : Bool,dict:[String:Any]){
        self.id = id
        self.groupChat = groupChat
        self.text = dict[.text] as? String ?? ""
        let type = dict[.type] as? String ?? ""
        self.type = MessageType(type) ?? .text
        self.ownerUid = dict[.ownerUid] as? String ?? ""
        let timeInterval = dict[.timeStamp] as? TimeInterval ?? 0
        self.timeStamp = Date(timeIntervalSince1970: timeInterval)
    }
}

extension String {
    static let `type` = "type"
    static let timeStamp = "timeStamp"
    static let ownerUid = "ownerUid"
    static let text = "text"
}
