//
//  BubbleImageView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import SwiftUI
import Kingfisher

struct BubbleImageView: View {
    let item: MessageItems
    var body: some View {
        HStack(alignment: .bottom){
            if item.showGroupPartnerInfo {
                CircularProfileImageView(item.sender?.profileImageUrl,size: .mini)
            }
            if item.direction == .sent {Spacer()}
            HStack{
                if item.direction == .sent {shareButton()}
                    messageTextView()
                    .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x: 0,y: 20)
                    .overlay {
                        playButton()
                            .opacity(item.type == .video ? 1 : 0)
                    }
                if item.direction == .received {shareButton()}
            }
            if item.direction == .received {Spacer()}
        }
        .padding(.horizontal, 10)
        .padding(.leading,item.leadingPaddings-20)
        .padding(.trailing,item.trailingPaddings)
    }
    private func playButton() -> some View {
        Image(systemName: "play.fill")
            .padding()
            .imageScale(.large)
            .foregroundStyle(.gray)
            .background(.thinMaterial)
            .clipShape(.circle)
        
    }
    
    private func messageTextView() -> some View {
        VStack(alignment:.leading){
            KFImage(URL(string: item.thumbNailUrl ?? ""))
                .resizable()
                .placeholder {ProgressView()}
                .scaledToFill()
                .frame(width: 220,height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .background{
                    (RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .fill(Color(.systemGray5))
                }
                .overlay(
                    (RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .stroke(Color(.systemGray5))
                )
                .overlay(alignment: .bottomTrailing, content: {
                    timeStampTextView()
                })
                .padding(5)
            
            if !item.text.isEmptyOrWhiteSpace {
                Text(item.text)
                    .padding([.horizontal,.bottom],8)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .frame(width:220)
            }
        }
        .background(item.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .applyTail(item.direction)
    }
    
    private func shareButton() -> some View {
        Button{
            
        }label: {
            Image(systemName: "arrowshape.turn.up.right.fill")
                .padding(10)
                .padding(.bottom,2)
                .foregroundStyle(.white)
                .background(Color.gray)
                .background(.thinMaterial)
                .clipShape(.circle)
        }
        .frame(width: 40, height: 40)
    }
    
    private func timeStampTextView() -> some View {
        HStack{
            Text(item.timeStamp.formatToTime)
                .font(.system(size: 12))
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width:15,height:15)
                    .foregroundStyle(Color.blue)
            }
        }
        .padding(.vertical,3)
        .padding(.horizontal,8)
        .foregroundStyle(.white)
        .background(Color(.systemGray))
        .clipShape(.capsule)
        .padding(6)
    }
}

#Preview {
    ScrollView{
        BubbleImageView(item: .sentplaceholder)
        BubbleImageView(item: .receiveplaceholder)
    }
    .frame(maxWidth: .infinity)
    .background(.black)
}
 
