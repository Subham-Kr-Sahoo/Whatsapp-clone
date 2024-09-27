//
//  ChatPartnerPickerViewModel.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 22/09/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

enum chatCreationRoute {
    case addGroupChatMembers
    case setUpGroupChat
}
enum channelContents {
    static let maxGroupParticipants: Int = 12
}
enum channelCreationError: Error {
    case emptyChatPartner
    case failedToCreateUniqueIds
}

@MainActor
final class ChatPartnerPickerViewModel : ObservableObject {
    @Published var navStack = [chatCreationRoute]()
    @Published var selectedChatPartner = [UserItems]()
    @Published private(set) var users = [UserItems]()
    private var lastCursor : String?
    
    var showSelectedUser: Bool {
        return !selectedChatPartner.isEmpty
    }
    var disabledNextButton: Bool {
        return selectedChatPartner.count < 2
    }
    var isPaginateable : Bool {
        return !users.isEmpty
    }
    private var isDirectchannel: Bool {
        return selectedChatPartner.count == 1
    }
    init(){
        Task{
            await fetchUsers()
        }
    }
    
    func fetchUsers() async {
        do{
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 10)
            var fetchedUsers = userNode.users
            guard let currentUid = Auth.auth().currentUser?.uid else {return}
            fetchedUsers = fetchedUsers.filter {$0.uid != currentUid} // isme kya ho rha he kie : user khud ko dekh paa rha tha group add member me lekin woh nhi hona chaiye so yeh logic usko bachata he
            self.users.append(contentsOf: fetchedUsers)
            self.lastCursor = userNode.currentCursor
        }catch{
            print("Failed to fetch users...")
        }
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
//    func buidDirectChannel() async -> Result<ChatItem,Error>{
//        
//    }
    func createChannel(_ channelName:String?) -> Result<ChatItem,Error> {
        guard !selectedChatPartner.isEmpty else {return .failure(channelCreationError.emptyChatPartner)}
        guard
            let channelId = FirebaseConstants.channelsRef.childByAutoId().key,
            let currentUid = Auth.auth().currentUser?.uid
            //let messageId = FirebaseConstants.messagesRef.childByAutoId().key
        else {return .failure(channelCreationError.failedToCreateUniqueIds)}
        let timeStamp = Date().timeIntervalSince1970
        var membersUid = selectedChatPartner.compactMap {$0.uid}
        membersUid.append(currentUid)
        var channelDict : [String:Any] = [
            .id:channelId,
            .lastMessage:"",
            .creationDate:timeStamp,
            .lastMessageTimeStamp:timeStamp,
            .memberUids:membersUid,
            .membersCount:membersUid.count,
            .adminUids:[currentUid]
        ]
        if let channelName = channelName , !channelName.isEmptyOrWhiteSpace {
            channelDict[.name] = channelName
        }
        FirebaseConstants.channelsRef.child(channelId).setValue(channelDict)
        membersUid.forEach{userId in
            // keeping an index of the channel where the user belongs to
            FirebaseConstants.userChannelsRef.child(userId).child(channelId).setValue(true)
        }
        // keeps sure that a direct channel is unique
        if isDirectchannel {
            let chatPartner = selectedChatPartner[0]
            // user-direct-channels/uid/uid/channelid
            FirebaseConstants.userDirectChannels.child(currentUid).child(chatPartner.uid).setValue([channelId: true])
            FirebaseConstants.userDirectChannels.child(chatPartner.uid).child(currentUid).setValue([channelId: true])
        }
        var newChannelItem = ChatItem(channelDict)
        newChannelItem.members = selectedChatPartner
        return .success(newChannelItem)
    }
}
