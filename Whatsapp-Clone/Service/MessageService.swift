//
//  MessageService.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 29/09/24.
//

import Foundation

struct MessageService {
    static func sendTextMessage(to channel: ChatItem,from currentUser: UserItems,_ text: String, onComplete: () -> Void){
        let timeStamp = Date().timeIntervalSince1970
        guard let messageId = FirebaseConstants.messagesRef.childByAutoId().key else { return }
        let channelDict : [String:Any] = [
            .lastMessage : text,
            .lastMessageTimeStamp : timeStamp
        ]
        let messageDict : [String:Any] = [
            .text:text,
            .type:MessageType.text.title,
            .timeStamp : timeStamp,
            .ownerUid: currentUser.uid,
        ]
        FirebaseConstants.channelsRef.child(channel.id).updateChildValues(channelDict)
        FirebaseConstants.messagesRef.child(channel.id).child(messageId).setValue(messageDict)
        onComplete()
    }
    
    static func getMessage(for chat: ChatItem, onComplete: @escaping([MessageItems]) -> Void){
        FirebaseConstants.messagesRef.child(chat.id).observe(.value) { snapshot in
            guard let dict = snapshot.value as? [String:Any] else { return }
            var messages : [MessageItems] = []
            dict.forEach { key, value in
                let messageDict = value as? [String:Any] ?? [:]
                let message = MessageItems(id: key, dict: messageDict)
                messages.append(message)
                if messages.count == snapshot.childrenCount {
                    messages.sort {$0.timeStamp < $1.timeStamp}
                    onComplete(messages)
                }
                
            }
        }withCancel: { error in
            print("\(error.localizedDescription)")
        }
    }
}
