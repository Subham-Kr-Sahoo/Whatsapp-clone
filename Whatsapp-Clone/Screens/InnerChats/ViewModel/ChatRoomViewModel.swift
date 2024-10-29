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
    @Published var imageEditorState : (show: Bool ,image: UIImage?) = (false,nil)
    @Published var isRecordingVoiceMesaage : Bool = false
    @Published var elapsedVoiceMessageTime : TimeInterval = 0
    @Published var scrollToBottomRequest : (scroll: Bool ,isAnimated: Bool) = (false,false)
    @Published var imagePreviewState : (show: Bool, image: String?, text: String) = (false,nil,"")
    private let audioRecorderService = AudioRecorderService()
    var showPhotoPickerPreview : Bool {
        return !mediaAttachments.isEmpty || !photoPickerItems.isEmpty
    }
    
    var disableSendButton: Bool {
        return mediaAttachments.isEmpty && textMessage.isEmptyOrWhiteSpace
    }
    
    init(_ chat: ChatItem) {
        self.chat = chat
        listenToAuthState()
        onPhotoPickerSelection()
        setUpVoiceRecorderListener()
    }
    
    deinit {
        subscription.forEach{
            $0.cancel()
        }
        subscription.removeAll()
        currentUser = nil
        audioRecorderService.tearDown()
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
    
    private func setUpVoiceRecorderListener(){
        audioRecorderService.$isRecording.receive(on: DispatchQueue.main).sink { [weak self] isRecording in
            self?.isRecordingVoiceMesaage = isRecording
        }.store(in: &subscription)
        
        audioRecorderService.$elapsedTime.receive(on: DispatchQueue.main).sink { [weak self] elapsedTime in
            self?.elapsedVoiceMessageTime = elapsedTime
        }.store(in: &subscription)
    }
    
    func sendMessage() {
        guard let currentUser else { return }
        if mediaAttachments.isEmpty {
            // it has to be a text message
            MessageService.sendTextMessage(to: chat, from: currentUser, textMessage) {[weak self] in
                self?.textMessage = ""
                self?.scrollToBottom(isAnimated: true)
            }
        }else{
            // else it can be a image or video or audio or document(going to make it in future))
            sendMultipleMediaMessage(textMessage, attachments: mediaAttachments)
            clearTextInputArea()
        }
    }
    
    private func scrollToBottom(isAnimated: Bool){
        scrollToBottomRequest.scroll = true
        scrollToBottomRequest.isAnimated = isAnimated
    }
    
    private func clearTextInputArea() {
        mediaAttachments.removeAll()
        photoPickerItems.removeAll()
        textMessage = ""
        UIApplication.dismissKeyboard()
    }
    
    private func sendMultipleMediaMessage(_ text:String, attachments: [MediaAttachment]){
        mediaAttachments.forEach {attachment in
            switch attachment.type {
            case .photo:
                sendPhotoMessage(text, attachment)
            case .video:
                sendVideoMessage(text, attachment)
            case .audio:
                sendVoiceMessage(text, attachment)
            }
        }
    }
    
    private func sendVoiceMessage(_ text: String, _ attachment: MediaAttachment){
        guard let audioDuration = attachment.audioDuration, let currentUser else { return }
        uploadFileToStorage(for: .audioMessage, attachment) {[weak self] fileUrl in
            guard let self = self else {return}
            let uploadParams = MessageUploadParams(channel: self.chat,
                                                   text: text,
                                                   type: .audio,
                                                   attachment: attachment,
                                                   sender: currentUser,
                                                   audioUrl: fileUrl.absoluteString,
                                                   audioDuration: audioDuration)
            
            MessageService.sendMediaMessage(to: chat, params: uploadParams) { [weak self] in
                self?.scrollToBottom(isAnimated: true)
            }
        }
    }
    
    private func sendVideoMessage(_ text: String, _ attachment: MediaAttachment){
        // upload the video to the storage bucker
        uploadFileToStorage(for: .videoMessage, attachment) {[weak self] videoUrl in
            self?.uploadImageToStorage(attachment) {[weak self] imageUrl in
                guard let self = self , let currentUser else { return }
                let uploadParams = MessageUploadParams(channel: chat,
                                                       text: text,
                                                       type: .video,
                                                       attachment: attachment,
                                                       thumbNailURL: imageUrl.absoluteString,
                                                       videoUrl: videoUrl.absoluteString,
                                                       sender: currentUser)
                MessageService.sendMediaMessage(to: chat, params: uploadParams) { [weak self] in
                    self?.scrollToBottom(isAnimated: true)
                }
            }
        }
    }
    
    private func sendPhotoMessage(_ text: String, _ attachment: MediaAttachment){
        // upload the image to storage bucket
        uploadImageToStorage(attachment) {[weak self] imageUrl in
            // after uploading store the metadata
            guard let self = self , let currentUser else { return }
            let uploadParams = MessageUploadParams(channel: chat,
                                                   text: text,
                                                   type: .photo,
                                                   attachment: attachment,
                                                   thumbNailURL: imageUrl.absoluteString,
                                                   sender: currentUser)
            MessageService.sendMediaMessage(to: chat, params: uploadParams) {[weak self] in
                // TODO: scroll to bottom upon upload success
                self?.scrollToBottom(isAnimated: true)
            }
        }
        
    }
    
    private func uploadImageToStorage(_ attachment: MediaAttachment, completion: @escaping (_ imageUrl: URL)-> Void){
        FirebaseHelper.uploadImage(attachment.thumbNail, for: .photoMessage) { result in
            switch result {
            case .success(let imageUrl):
                completion(imageUrl)
                
            case .failure(let error):
                print("failed to upload image to storage \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD IMAGE PROGRESS: \(progress)")
        }
    }
    
    private func uploadFileToStorage(for uploadType: FirebaseHelper.uploadType,
                                          _ attachment: MediaAttachment,
                                        completion: @escaping (_ fileUrl: URL)-> Void){
        guard let fileToUpload = attachment.fileUrl else {return}
        FirebaseHelper.uploadfile(for: uploadType, fileURL: fileToUpload) { result in
            switch result {
            case .success(let fileUrl):
                completion(fileUrl)
                
            case .failure(let error):
                print("failed to upload file to storage \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD FILE PROGRESS: \(progress)")
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
        case .recordAudio:
            toggleAudioRecorder()
        }
    }
    
    private func toggleAudioRecorder() {
        if audioRecorderService.isRecording {
            // stop recording
            audioRecorderService.stopRecording {[weak self] audioUrl, audioDuration in
                self?.createAudioAttachment(from: audioUrl, audioDuration)
            }
        }else{
            // start recording then
            audioRecorderService.startRecording()
        }
    }
    
    private func createAudioAttachment(from audioUrl : URL?,_ audioDuration:TimeInterval){
        guard let audioUrl = audioUrl else {return}
        let id = UUID().uuidString
        let audioAttachment = MediaAttachment(id: id, type: .audio(audioUrl,audioDuration))
        mediaAttachments.insert(audioAttachment, at: 0)
    }
    
    private func onPhotoPickerSelection() {
        $photoPickerItems.sink { [weak self] photos in
            guard let self = self else {return}
            // just to adjust the duplicate but have to find a logical logic 
            // self.mediaAttachments.removeAll()
            let audioRecordings = mediaAttachments.filter({ $0.type == .audio(.stubUrl,.stubTimeInterval) })
            self.mediaAttachments = audioRecordings
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
    
    func showImagePreview(_ image : String, _ text : String){
        imagePreviewState.show = true
        imagePreviewState.image = image
        imagePreviewState.text = text
    }
    
    func dismissImagePreview(){
        imagePreviewState.show = false
        imagePreviewState.image = nil
        imagePreviewState.text = ""
    }
    
    func handleMediaAttachmentPreview(_ action : MediaAttachmentPreview.userAction) {
        switch action {
        case .play(let attachment):
            guard let fileUrl = attachment.fileUrl else { return }
            showMediaPlayer(fileUrl)
        case .remove(let attachment):
            remove(attachment)
            guard let fileUrl = attachment.fileUrl else { return }
            if attachment.type == .audio(.stubUrl,.stubTimeInterval){
                audioRecorderService.deleteRecording(at: fileUrl)
            }
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
