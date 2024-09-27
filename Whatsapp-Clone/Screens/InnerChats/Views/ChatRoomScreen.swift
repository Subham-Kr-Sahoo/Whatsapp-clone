//
//  ChatRoomScreen.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import SwiftUI

struct ChatRoomScreen: View {
    let channel : ChatItem
    var body: some View {
        MessageListView()
        .toolbar(.hidden,for: .tabBar)
        .toolbar{
            leadingNavItems()
            trailingNavItems()
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
    }
}
extension ChatRoomScreen {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack{
                Circle()
                    .frame(width:40,height:40)
                Text(channel.title)
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
