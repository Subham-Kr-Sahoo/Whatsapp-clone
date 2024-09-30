//
//  ChannelItem.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 27/09/24.
//

import Foundation
import Firebase
import FirebaseAuth

struct ChatItem : Identifiable {
    var id: String
    var name : String?
    var lastMessage : String
    var creationDate : Date
    var lastMessageTimeStamp : Date
    var membersCount : Int
    var adminUids : [String]
    var memberUids : [String]
    var members : [UserItems]
    var thumbNailUrL : String?
    let createdBy : String
    
    var groupChannel : Bool {
        return membersCount > 2
    }
    
    var membersExcludeingMe : [UserItems] {
        guard let currentUid = Auth.auth().currentUser?.uid else {return []}
        return members.filter {$0.uid != currentUid}
    }
    
    var title: String {
        if let name = name {
            return name
        }
        if groupChannel {
            return "Group Chat"
        } else {
            return membersExcludeingMe.first?.username ?? "Unknown member"
        }
    }
    
    var iscreatedByMe : Bool {
        return createdBy == Auth.auth().currentUser?.uid ?? ""
    }
    
    var creatorName : String {
        return members.first {$0.uid == createdBy}?.username ?? "SomeOne"
    }
    
    static let placeholder = ChatItem.init(id: "1", lastMessage: "Hello World", creationDate: Date(), lastMessageTimeStamp: Date(), membersCount: 2, adminUids: [], memberUids: [], members: [],createdBy: "")
    
}
extension ChatItem {
    init (_ dict: [String:Any]){
        self.id = dict[.id] as? String ?? ""
        self.name = dict[.name] as? String? ?? nil
        self.lastMessage = dict[.lastMessage] as? String ?? ""
        let creationInterval = dict[.creationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: creationInterval)
        let lastMessageTimeStamp = dict[.lastMessageTimeStamp] as? Double ?? 0
        self.lastMessageTimeStamp = Date(timeIntervalSince1970: lastMessageTimeStamp)
        self.membersCount = dict[.membersCount] as? Int ?? 0
        self.adminUids = dict[.adminUids] as? [String] ?? []
        self.memberUids = dict[.memberUids] as? [String] ?? []
        self.members = dict[.members] as? [UserItems] ?? []
        self.thumbNailUrL = dict[.thumbNailUrl] as? String ?? nil
        self.createdBy = dict[.createdBy] as? String ?? ""
    }
}
extension String {
    static let id = "id"
    static let name = "name"
    static let lastMessage = "lastMessage"
    static let creationDate = "creationDate"
    static let lastMessageTimeStamp = "lastMessageTimeStamp"
    static let membersCount = "membersCount"
    static let adminUids = "adminUids"
    static let memberUids = "memberUids"
    static let thumbNailUrl = "thumbNailUrl"
    static let members = "members"
    static let createdBy = "createdBy"
}

