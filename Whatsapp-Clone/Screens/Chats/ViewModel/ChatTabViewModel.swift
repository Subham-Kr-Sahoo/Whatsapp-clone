//
//  ChatTabViewModel.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 27/09/24.
//

import Foundation

final class ChatTabViewModel : ObservableObject {
    @Published var navigateToChatRoom = false
    @Published var newChat : ChatItem?
    @Published var showNewMemberAddScreen = false
    
    func onNewChatCreation(_ chat: ChatItem){
        showNewMemberAddScreen = false
        newChat = chat
        navigateToChatRoom = true
    }
}
