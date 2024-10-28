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
import Combine

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
    @Published private(set) var users = Set<UserItems>()
    @Published var errorState : (showError: Bool, errorMessage: String) = (false,"Error")
    private var lastCursor : String?
    private var subscription: AnyCancellable?
    private var currentUser : UserItems?
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
        listenforAuthState()
    }
    
    deinit {
        subscription?.cancel()
        subscription = nil
    }
    
    private func listenforAuthState(){
        subscription = AuthManager.shared.authState.receive(on: DispatchQueue.main).sink { [weak self] authState in
            switch authState{
            case .loggedIn(let currentUser):
                self?.currentUser = currentUser
                Task{ await self?.fetchUsers() }
            default:
                break
            }
        }
    }
    
    func fetchUsers() async {
        do{
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 10)
            // here the users page is constantly fetching the duplicates , i dont know why may be some where users from groupMember arrays are mixing in it or something else is happening , i have to give it time to check it
            var fetchedUsers = userNode.users
            guard let currentUid = Auth.auth().currentUser?.uid else {return}
            fetchedUsers = fetchedUsers.filter {$0.uid != currentUid} // isme kya ho rha he kie : user khud ko dekh paa rha tha group add member me lekin woh nhi hona chaiye so yeh logic usko bachata he
            for fetchedUser in fetchedUsers {
                self.users.insert(fetchedUser) //fetchedUsers mujhe ek array de rha he so me kya kar rha hu kie array ko traverse then push it into set , so duplicates are get removed 
            }
            self.lastCursor = userNode.currentCursor
        }catch{
            print("Failed to fetch users...")
        }
    }
    
    func deselectAllChatPartners(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5){
            self.selectedChatPartner.removeAll()
        }
    }
    
    func handleItemSelection(_ item: UserItems) {
        if isUserSelected(item){ // deselect
            guard let index = selectedChatPartner.firstIndex(where:{$0.uid == item.uid}) else {return}
            selectedChatPartner.remove(at: index)
        }else{ // select that user
            guard selectedChatPartner.count < channelContents.maxGroupParticipants else {
                let errorMessage = "Sorry you can't add more than \(channelContents.maxGroupParticipants) people to a group."
                showError(errorMessage)
                return
            }
            selectedChatPartner.append(item)
        }
    }
    func isUserSelected(_ user: UserItems) -> Bool {
        let isSelected = selectedChatPartner.contains {$0.uid == user.uid}
        return isSelected
    }
    func createDirectChannel(_ chatPartner:UserItems,completion: @escaping (_ newChannel: ChatItem) -> Void){
        selectedChatPartner.append(chatPartner)
        Task{
            // if existing channel then , get the channel
            if let channelId = await verifyDirectChannelExists(with: chatPartner.uid){
                let snapshot = try await FirebaseConstants.channelsRef.child(channelId).getData()
                let chanelDict = snapshot.value as! [String: Any]
                var directChannel = ChatItem(chanelDict)
                directChannel.members = selectedChatPartner
                if let currentUser {
                    directChannel.members.append(currentUser)
                }
                completion(directChannel)
            }else{
                // create a new DM with the user
                let channelCreation = createChannel(nil)
                switch channelCreation {
                case .success(let channel):
                    completion(channel)
                case .failure(let failure):
                    showError("Sorry! Something went wrong while we were trying setup your chat")
                    print("Failed to create a Direct channel: \(failure.localizedDescription)")
                }
            }
        }
    }
    
    typealias channelId = String
    private func verifyDirectChannelExists(with chatPartnerId: String) async -> channelId? {
        guard let currentUid = Auth.auth().currentUser?.uid,
              let snapShot = try? await FirebaseConstants.userDirectChannels.child(currentUid).child(chatPartnerId).getData(),
              snapShot.exists()
        else {
            return nil
        }
        let directMessageDict = snapShot.value as! [String:Bool]
        let channelId = directMessageDict.compactMap {$0.key}.first
        return channelId
    }
    func createGroupChannel(_ groupName: String, completion: @escaping (_ newChannel: ChatItem) -> Void){
        let channelCreation = createChannel(groupName)
        switch channelCreation {
        case .success(let channel):
            completion(channel)
        case .failure(let failure):
            showError("Sorry! Something went wrong while we were trying setup your group chat")
            print("Failed to create a Group channel: \(failure.localizedDescription)")
        }
    }
    private func showError(_ errorMessage: String) {
        errorState.errorMessage = errorMessage
        errorState.showError = true
    }
    private func createChannel(_ channelName:String?) -> Result<ChatItem,Error> {
        guard !selectedChatPartner.isEmpty else {return .failure(channelCreationError.emptyChatPartner)}
        guard
            let channelId = FirebaseConstants.channelsRef.childByAutoId().key,
            let currentUid = Auth.auth().currentUser?.uid,
            let messageId = FirebaseConstants.messagesRef.childByAutoId().key
        else {return .failure(channelCreationError.failedToCreateUniqueIds)}
        let timeStamp = Date().timeIntervalSince1970
        var membersUid = selectedChatPartner.compactMap {$0.uid}
        membersUid.append(currentUid)
        
        let newChannelBroadCast = AdminMessageType.channelCreation.rawValue
        
        var channelDict : [String:Any] = [
            .id:channelId,
            .lastMessage:newChannelBroadCast,
            .creationDate:timeStamp,
            .lastMessageTimeStamp:timeStamp,
            .memberUids:membersUid,
            .membersCount:membersUid.count,
            .adminUids:[currentUid],
            .createdBy: currentUid
        ]
        if let channelName = channelName , !channelName.isEmptyOrWhiteSpace {
            channelDict[.name] = channelName
        }
        let messageDict : [String:Any] = [.type: newChannelBroadCast, .timeStamp:timeStamp, .ownerUid:currentUid]
        FirebaseConstants.channelsRef.child(channelId).setValue(channelDict)
        FirebaseConstants.messagesRef.child(channelId).child(messageId).setValue(messageDict)
        
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
        if let currentUser {
            newChannelItem.members.append(currentUser)
        }
        return .success(newChannelItem)
    }
}
