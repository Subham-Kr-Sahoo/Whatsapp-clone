//
//  BubbleAudioView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import SwiftUI

struct BubbleAudioView: View {
    let item : MessageItems
    @State private var sliderValue : Double = 0
    @State private var sliderRange : ClosedRange<Double> = 0...20
    var body: some View {
        HStack(alignment:.bottom){
            if item.showGroupPartnerInfo {
                CircularProfileImageView(item.sender?.profileImageUrl, size: .mini)
            }
            VStack(alignment:item.horizontalAlignment,spacing: 3){
                HStack{
                    playButton()
                    Slider(value: $sliderValue,in: sliderRange)
                        .tint(.gray)
                    Text("03:58")
                        .foregroundStyle(.gray)
                }
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(8)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .applyTail(item.direction)
                timeStampView()
            }
            .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5,x: 0,y: 20)
            .frame(maxWidth: .infinity,alignment: item.alignment)
            .padding(.leading,item.leadingPaddings)
            .padding(.trailing,item.trailingPaddings)
        }
    }
    private func playButton() -> some View {
        Button{
            
        }label: {
            Image(systemName: "play.fill")
                .padding(.leading,2)
                .padding(10)
                .background(item.direction == .sent ? .whatsAppWhite : .green)
                .clipShape(.circle)
                .foregroundStyle(item.direction == .sent ? .black : .white)
        }
    }
    private func timeStampView() -> some View {
        HStack {
            Text("3:25 AM")
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
        BubbleAudioView(item: .sentplaceholder)
        BubbleAudioView(item: .receiveplaceholder)
    }
    .frame(maxWidth:.infinity)
    .padding(.horizontal)
    .background(.black)
    .onAppear{
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }
}
