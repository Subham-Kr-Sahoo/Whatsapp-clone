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
    private let chat: ChatItem
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
            switch authState {
            case .loggedIn(let currentUser) :
                self?.currentUser = currentUser
                self?.getMessage()
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
            print(messages.map {$0.text})
        }
    }
}
