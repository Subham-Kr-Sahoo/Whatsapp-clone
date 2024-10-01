//
//  BubbleTextView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import SwiftUI

struct BubbleTextView: View {
    let item : MessageItems
    var body: some View {
        VStack(alignment:item.horizontalAlignment,spacing:3){
            HStack(alignment:.bottom){
                if item.showGroupPartnerInfo {
                    CircularProfileImageView(item.sender?.profileImageUrl,size: .mini)
                        .padding(.leading,-10)
                }
                Text(item.text)
                    .padding(10)
                    .background(item.backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .applyTail(item.direction)
                    .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x: 0,y: 20)
                    .frame(maxWidth: .infinity,alignment: item.alignment)
                    .padding(.leading,item.leadingPaddings)
                    .padding(.trailing,item.trailingPaddings)
            }
            timeStampTextView()
                .padding(.leading,item.showGroupPartnerInfo ? 30 : 0)
        }
    }
    private func timeStampTextView() -> some View {
        HStack {
            Text(item.timeStamp.formatToTime)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
            
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width:15,height: 18)
                    .foregroundStyle(Color.blue)
            }
        }
    }
}

#Preview {
    ScrollView {
        BubbleTextView(item: .sentplaceholder)
        BubbleTextView(item: .receiveplaceholder)
    }
    .frame(maxWidth: .infinity)
    .background(.black)
}
