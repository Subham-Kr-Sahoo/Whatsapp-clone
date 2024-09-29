//
//  ChatTabViewModel.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 27/09/24.
//

import Foundation
import Firebase
import FirebaseAuth

final class ChatTabViewModel : ObservableObject {
    @Published var navigateToChatRoom = false
    @Published var newChat : ChatItem?
    @Published var showNewMemberAddScreen = false
    @Published var channels = [ChatItem]()
    init(){
        fetchCurrentUserChats()
    }
    
    func onNewChatCreation(_ chat: ChatItem){
        showNewMemberAddScreen = false
        newChat = chat
        navigateToChatRoom = true
    }
    
    private func fetchCurrentUserChats(){
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        FirebaseConstants.userChannelsRef.child(currentUid).observe(.value) { [weak self]snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            dict.forEach { key,value in
                let channelId = key
                self?.getChat(with: channelId)
            }
        } withCancel: { error in
            print("Failed to get current user's chats:\(error.localizedDescription)")
        }
    }
    
    private func getChat(with channelId: String){
        FirebaseConstants.channelsRef.child(channelId).observe(.value) { [weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            var channel = ChatItem(dict)
            self?.getChatMembers(channel, completion: { members in
                channel.members = members
                self?.channels.append(channel)
                print(channel.title)
            })
            
        } withCancel: { error in
            print("Failed to get current user's chats:\(error.localizedDescription)")
        }
    }
    private func getChatMembers(_ channel: ChatItem, completion: @escaping (_ members: [UserItems]) -> Void){
        UserService.getUsers(with: channel.memberUids) { usernode in
            completion(usernode.users)
        }
    }
}
