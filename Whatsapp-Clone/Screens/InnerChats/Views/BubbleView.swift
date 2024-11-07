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
    let showSenderName: Bool
    var padding : CGFloat {
        switch message.type {
        case .text,.audio:
            return -10
        case .photo,.video:
            return 10
        default:
            return 0
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            if isNewDay {
                newDayTimeStampView()
                    .padding(6)
            }
            if showSenderName {
                senderNameTextView()
                    .padding(.leading,padding)
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
                .padding(.trailing, 10)
        case .photo,.video :
            BubbleImageView(item: message)
                .padding(.leading ,chat.groupChannel == false ? -10 : 0)
        case .audio :
            BubbleAudioView(item : message)
                .padding(.leading ,chat.groupChannel == false ? -10 : 0)
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
    
    private func senderNameTextView() -> some View {
        Text(message.sender?.username ?? "Unknown")
            .lineLimit(1)
            .foregroundStyle(.gray)
            .font(.footnote)
            .padding(.bottom,2)
            .padding(.horizontal)
            .padding(.leading,30)
    }
}

#Preview {
    BubbleView(message: .sentplaceholder, chat: .placeholder, isNewDay: false, showSenderName: false)
}
