//
//  BubbleView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 07/11/24.
//

import SwiftUI

struct BubbleView: View {
    let message: MessageItems
    let chat: ChatItem
    let isNewDay: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            if isNewDay {
                newDayTimeStampView()
                    .padding(6)
            }
            composeDynamicBubbleView()
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func composeDynamicBubbleView() -> some View {
        switch message.type {
        case .text :
            BubbleTextView(item: message)
        case .photo,.video :
            BubbleImageView(item: message)
        case .audio :
            BubbleAudioView(item : message)
        case .admin(let type):
            switch type {
            case .channelCreation:
                newDayTimeStampView()
                ChannelCreationTextView()
                    .padding(6)
                if chat.groupChannel{
                    AdminMessageTextView(chat: chat)
                }
            default:
                Text("")
            }
        }
    }
    
    private func newDayTimeStampView() -> some View {
        Text(message.timeStamp.relativeDateString)
            .font(.caption)
            .bold()
            .padding(.vertical,3)
            .padding(.horizontal)
            .background(.whatsAppGray)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    BubbleView(message: .sentplaceholder, chat: .placeholder, isNewDay: false)
}
