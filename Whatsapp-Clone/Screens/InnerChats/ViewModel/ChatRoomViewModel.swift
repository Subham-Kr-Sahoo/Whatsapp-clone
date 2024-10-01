//
//  ChatRoomViewModel.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 29/09/24.
//

import Foundation
import Combine

final class ChatRoomViewModel : ObservableObject {
    @Published var textMessage = ""
    private(set) var chat: ChatItem
    private var currentUser: UserItems?
    private var subscription = Set<AnyCancellable>()
    @Published var messages: [MessageItems] = []
    init(_ chat: ChatItem) {
        self.chat = chat
        listenToAuthState()
    }
    deinit {
        subscription.forEach{
            $0.cancel()
        }
        subscription.removeAll()
        currentUser = nil
    }
    private func listenToAuthState() {
        AuthManager.shared.authState.receive (on: DispatchQueue.main).sink {[weak self] authState in
            guard let self = self else {return}
            switch authState {
            case .loggedIn(let currentUser) :
                self.currentUser = currentUser
                if self.chat.allMembersFetched {
                    self.getMessage()
                    print("\(chat.members.map {$0.username})")
                }else{
                    self.getAllChannelMembers()
                }
            default :
                break
            }
        }.store(in: &subscription)
    }
    func sendMessage() {
        guard let currentUser else { return }
        MessageService.sendTextMessage(to: chat, from: currentUser, textMessage) {[weak self] in
            self?.textMessage = ""
        }
    }
    private func getMessage(){
        MessageService.getMessage(for: chat) { [weak self] messages in
            self?.messages = messages
        }
    }
    private func getAllChannelMembers() {
        guard let currentUser = currentUser else {return}
        let membersAlreadyfetched = chat.members.compactMap{$0.uid}
        var membersUidToFetch = chat.memberUids.filter {!membersAlreadyfetched.contains($0)}
        membersUidToFetch = membersUidToFetch.filter {$0 != currentUser.uid}
        UserService.getUsers(with: membersUidToFetch) { [weak self] userNode in
            guard let self = self else {return}
            self.chat.members.append(contentsOf: userNode.users)
            self.getMessage()
            print("\(chat.members.map {$0.username})")
        }
    }
}
