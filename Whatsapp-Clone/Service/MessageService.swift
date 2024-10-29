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
                let message = MessageItems(id: key,groupChat: chat.groupChannel ,dict: messageDict)
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
    
    static func sendMediaMessage(to channel: ChatItem, params: MessageUploadParams, completion: @escaping ()->Void){
        guard let messageId = FirebaseConstants.messagesRef.childByAutoId().key else { return }
        let timeStamp = Date().timeIntervalSince1970
        let channelDict : [String:Any] = [
            .lastMessage : params.text,
            .lastMessageTimeStamp : timeStamp,
            .lastMessageType : params.type.title
        ]
        var messageDict : [String:Any] = [
            .text:params.text,
            .type:params.type.title,
            .timeStamp : timeStamp,
            .ownerUid: params.ownerUid,
            
        ]
        // photo messages
        messageDict[.thumbNailUrl] = params.thumbNailURL ?? nil
        messageDict[.thumbNailWidth] = params.thumbNailWidth ?? nil
        messageDict[.thumbNailHeight] = params.thumbNailHeight ?? nil
        // video messages
        messageDict[.videoUrl] = params.videoUrl ?? nil
        // voice messages
        messageDict[.audioUrl] = params.audioUrl ?? nil
        messageDict[.audioDuration] = params.audioDuration ?? nil
        
        FirebaseConstants.channelsRef.child(channel.id).updateChildValues(channelDict)
        FirebaseConstants.messagesRef.child(channel.id).child(messageId).setValue(messageDict)
        
        completion()
    }
}

struct MessageUploadParams {
    let channel : ChatItem
    let text : String
    let type: MessageType
    let attachment: MediaAttachment
    var thumbNailURL: String?
    var videoUrl: String?
    var sender: UserItems
    var audioUrl: String?
    var audioDuration: TimeInterval?
    
    var ownerUid : String {
        return sender.uid
    }
    
    var thumbNailWidth: CGFloat?{
        guard type == .photo || type == .video else { return nil }
        return attachment.thumbNail.size.width
    }
    var thumbNailHeight: CGFloat?{
        guard type == .photo || type == .video else { return nil }
        return attachment.thumbNail.size.height
    }
}
