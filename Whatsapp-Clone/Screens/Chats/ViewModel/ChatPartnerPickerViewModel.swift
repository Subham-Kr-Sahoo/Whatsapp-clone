//
//  ChatPartnerPickerViewModel.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 22/09/24.
//

import Foundation

enum chatCreationRoute {
    case addGroupChatMembers
    case setUpGroupChat
}
enum channelContents {
    static let maxGroupParticipants: Int = 12
}
final class ChatPartnerPickerViewModel : ObservableObject {
    @Published var navStack = [chatCreationRoute]()
    @Published var selectedChatPartner = [UserItems]()
    
    var showSelectedUser: Bool {
        return !selectedChatPartner.isEmpty
    }
    var disabledNextButton: Bool {
        return selectedChatPartner.count < 2
    }
    func handleItemSelection(_ item: UserItems) {
        if isUserSelected(item){ // deselect
            guard let index = selectedChatPartner.firstIndex(where:{$0.uid == item.uid}) else {return}
            selectedChatPartner.remove(at: index)
        }else{ // select that user
            selectedChatPartner.append(item)
        }
    }
    func isUserSelected(_ user: UserItems) -> Bool {
        let isSelected = selectedChatPartner.contains {$0.uid == user.uid}
        return isSelected
    }
}
