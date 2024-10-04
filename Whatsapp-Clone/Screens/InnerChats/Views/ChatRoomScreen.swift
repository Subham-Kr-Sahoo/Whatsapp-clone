//
//  ChatRoomScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import SwiftUI
import PhotosUI

struct ChatRoomScreen: View {
    let channel : ChatItem
    @StateObject private var viewModel : ChatRoomViewModel
    init(channel : ChatItem) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
    }
   
    var body: some View {
        MessageListView(viewModel: viewModel)
        .toolbar(.hidden,for: .tabBar)
        .toolbar{
            leadingNavItems()
            trailingNavItems()
        }
        .photosPicker(isPresented: $viewModel.showPhotoPicker, selection: $viewModel.photoPickerItems,maxSelectionCount: 12)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            bottomSafeAreaView()
        }
        .fullScreenCover(isPresented: $viewModel.videoPlayerState.show) {
            if let player = viewModel.videoPlayerState.player {
                MediaPlayerView(player: player) {
                    viewModel.dismissVideoPlayer()
                }
            }
        }
    }
    
    private func bottomSafeAreaView() -> some View {
        VStack(spacing: 0){
            if viewModel.showPhotoPickerPreview {
                MediaAttachmentPreview(mediaAttachments: viewModel.mediaAttachments){ action in
                    viewModel.handleMediaAttachmentPreview(action)
                }
            }
            TextInputArea(textMessage: $viewModel.textMessage){action in 
                viewModel.handleTextInputArea(action)
            }
        }
    }
}
extension ChatRoomScreen {
    private var channelTitle : String {
        let maxChar = 20
        let trailingChars = channel.title.count > maxChar ? "..." : ""
        let title = String(channel.title.prefix(maxChar) + trailingChars)
        return title
    }
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack{
                CircularProfileImageView(channel, size: .mini)
                Text(channelTitle)
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Button{
                    
                }label: {
                    Image(systemName: "video")
                }
                
                Button{
                    
                }label: {
                    Image(systemName: "phone")
                }
            }
            
            
        }
    }
}
#Preview {
    NavigationStack {
        ChatRoomScreen(channel: .placeholder)
    }
}
