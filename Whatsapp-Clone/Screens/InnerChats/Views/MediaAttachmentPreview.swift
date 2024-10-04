//
//  MediaAttachmentPreview.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 04/10/24.
//

import SwiftUI

struct MediaAttachmentPreview : View {
    let mediaAttachments : [MediaAttachment]
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(mediaAttachments){attachment in
                    thumbNailImageView(attachment)
                }
            }
            .padding(.horizontal,8)
        }
        .frame(height: Constants.listHeight)
        .frame(maxWidth: .infinity)
        .background(Color.clear)
    }
    private func thumbNailImageView(_ attachment : MediaAttachment) -> some View {
        Button{
            
        }label: {
            Image(uiImage: attachment.thumbNail)
                .resizable()
                .scaledToFill()
                .frame(width:Constants.imageDimension,height:Constants.imageDimension)
                .cornerRadius(5)
                .clipped()
                .overlay(alignment:.topTrailing){
                    cancelButton()
                }
                .overlay(alignment:.bottomLeading){
                    videoButton()
                        .opacity(attachment.type == .video(UIImage(),.stubUrl) ? 1 : 0)
                }
        }
    }
    private func cancelButton() -> some View {
        Button{
            
        }label: {
            Image(systemName: "xmark")
                .scaledToFit()
                .imageScale(.medium)
                .padding(5)
                .foregroundStyle(.black)
                .background(Color.white.opacity(0.5))
                .clipShape(.circle)
                .padding(2)
                .bold()
        }
    }
    
    private func videoButton() -> some View {
        Image(systemName: "video")
            .scaledToFit()
            .imageScale(.medium)
            .padding(5)
            .foregroundStyle(.white)
            .padding(2)
            .bold()
    }
    
    private func microPhoneButton() -> some View {
        Image(systemName: "mic")
            .scaledToFit()
            .imageScale(.medium)
            .padding(7)
            .foregroundStyle(.black)
            .background(Color.white.opacity(0.5))
            .clipShape(.circle)
            .padding(2)
    }
    
    private func audioAttachmentView() -> some View {
        ZStack{
            LinearGradient(colors: [.green,.green.opacity(0.5),.teal], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .scaledToFill()
        .frame(width:Constants.imageDimension*1.5,height:Constants.imageDimension)
        .cornerRadius(5)
        .clipped()
        .overlay(alignment: .topTrailing){
            cancelButton()
        }
        .overlay{
            microPhoneButton()
        }
        .overlay(alignment:.bottomLeading){
            Text("Hello World Music creation")
                .lineLimit(1)
                .font(.caption)
                .padding(2)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity,alignment: .center)
                .background(Color.white.opacity(0.5))
        }
    }
}

extension MediaAttachmentPreview {
    enum Constants {
        static let listHeight : CGFloat = 100
        static let imageDimension : CGFloat = 80
    }
}

#Preview {
    MediaAttachmentPreview(mediaAttachments: [])
}
