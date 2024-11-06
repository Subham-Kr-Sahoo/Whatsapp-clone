//
//  ChatsItemView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 16/09/24.
//

import SwiftUI

struct ChatsItemView: View {
    let channel : ChatItem
    var body: some View {
        HStack(alignment:.center,spacing: 10){
            CircularProfileImageView(channel,size:.medium)
            
            VStack(alignment:.leading,spacing: 6){
                titleTextView()
                lastMessagePreview()
            }
        }
    }
    private func titleTextView() -> some View {
        HStack{
            Text(channel.title)
                .lineLimit(1)
                .bold()
            
            Spacer()
            
            Text(channel.lastMessageTimeStamp.dayOrTimeRepresentation)
                .foregroundStyle(.gray)
                .font(.system(size: 15))
        }
    }
    
    private func lastMessagePreview() -> some View{
        HStack(spacing:0){
            Image(systemName: channel.lastMessageType.iconName)
                .imageScale(.small)
                .foregroundStyle(.gray)
            Text(channel.previewMessage)
                .font(.system(size: 16))
                .lineLimit(1)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ChatsItemView(channel: .placeholder)
}
