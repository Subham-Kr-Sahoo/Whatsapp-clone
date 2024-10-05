//
//  ChatRoomViewModel.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 29/09/24.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI

final class ChatRoomViewModel : ObservableObject {
    @Published var textMessage = ""
    private(set) var chat: ChatItem
    private var currentUser: UserItems?
    private var subscription = Set<AnyCancellable>()
    @Published var messages: [MessageItems] = []
    @Published var showPhotoPicker = false
    @Published var photoPickerItems : [PhotosPickerItem] = []
    @Published var mediaAttachments : [MediaAttachment] = []
    @Published var videoPlayerState : (show: Bool, player: AVPlayer?) = (false,nil)
    @Published var imageEditorState : (show:Bool ,image: UIImage?) = (false,nil)
    var showPhotoPickerPreview : Bool {
        return !photoPickerItems.isEmpty || !photoPickerItems.isEmpty
    }
    init(_ chat: ChatItem) {
        self.chat = chat
        listenToAuthState()
        onPhotoPickerSelection()
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
    
    func handleTextInputArea(_ action: TextInputArea.userAction) {
        switch action {
        case .presentPhotoPicker:
            showPhotoPicker = true
        case .sendMessage:
            sendMessage()
        }
    }
    
    private func onPhotoPickerSelection() {
        $photoPickerItems.sink { [weak self] photos in
            guard let self = self else {return}
            // just to adjust the duplicate but have to find a logical logic 
            self.mediaAttachments.removeAll()
            Task{
                await self.parsePhotoPickerItems(photos)
            }
        }
        .store(in: &subscription)
    }
    
    private func parsePhotoPickerItems(_ items: [PhotosPickerItem]) async {
        for photo in items {
            if photo.isVideo {
                if let video = try? await photo.loadTransferable(type: videoPickerTransferable.self) {
                    if let movie = try? await photo.loadTransferable(type: videoPickerTransferable.self),
                       let thumbNailImage = try? await movie.url.generateThumbnail(),
                        let itemIdentifier = photo.itemIdentifier
                    {
                        let videoAttachment = MediaAttachment(id: itemIdentifier, type: .video(thumbNailImage, movie.url))
                        await MainActor.run {
                            self.mediaAttachments.insert(videoAttachment, at: 0)
                        }
                    }
                }
            }else{
                guard
                let data = try? await photo.loadTransferable(type: Data.self),
                let thumbNail = UIImage(data:data),
                    let itemIdentifier = photo.itemIdentifier
                else {return}
                let photoAttachment = MediaAttachment(id: itemIdentifier, type: .photo(thumbNail))
                await MainActor.run {
                    self.mediaAttachments.insert(photoAttachment, at: 0)
                }
            }
        }
    }
    
    func dismissVideoPlayer() {
        videoPlayerState.player?.replaceCurrentItem(with: nil)
        videoPlayerState.player = nil
        videoPlayerState.show = false
    }
    
    func showMediaPlayer(_ fileUrl : URL){
        videoPlayerState.show = true
        videoPlayerState.player = AVPlayer(url: fileUrl)
    }
    
    func showImageEditor(_ image : UIImage){
        imageEditorState.show = true
        imageEditorState.image = image
    }
    
    func dismissImageEditor(){
        imageEditorState.show = false
        imageEditorState.image = nil
    }
    
    func handleMediaAttachmentPreview(_ action : MediaAttachmentPreview.userAction) {
        switch action {
        case .play(let attachment):
            guard let fileUrl = attachment.fileUrl else { return }
            showMediaPlayer(fileUrl)
        case .remove(let attachment):
            remove(attachment)
        case .edit(let attachment):
            let image = attachment.thumbNail
            showImageEditor(image)
        }
    }
    
    private func remove(_ item : MediaAttachment){
        guard let attachmentIndex = mediaAttachments.firstIndex(where: {$0.id == item.id}) else { return }
        mediaAttachments.remove(at: attachmentIndex)
        guard let photoIndex = photoPickerItems.firstIndex(where: {$0.itemIdentifier == item.id}) else { return }
        photoPickerItems.remove(at: photoIndex)
    }
}
