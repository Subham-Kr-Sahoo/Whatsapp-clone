//
//  BubbleAudioView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 18/09/24.
//

import SwiftUI
import AVKit

struct BubbleAudioView: View {
    @EnvironmentObject private var voiceMessagePlayer : VoiceMessagePlayer
    @State private var playBackState : VoiceMessagePlayer.playBackState = .stopped
    @State private var playBackTime : String = "00:00"
    private let item : MessageItems
    @State private var sliderValue : Double = 0
    @State private var sliderRange : ClosedRange<Double> = 0...20
    @State private var isDraggingSlider : Bool = false
    
    private var isCorrectVoiceMessage : Bool {
        return voiceMessagePlayer.currentUrl?.absoluteString == item.audioUrl
    }
    
    init (item: MessageItems) {
        self.item = item
        let audioDuration = item.audioDuration ?? 20
        self._sliderRange = State(wrappedValue: 0...audioDuration)
    }
    
    var body: some View {
        HStack(alignment:.bottom){
            if item.showGroupPartnerInfo {
                CircularProfileImageView(item.sender?.profileImageUrl, size: .mini)
            }
            VStack(alignment:item.horizontalAlignment,spacing: 3){
                HStack{
                    playButton()
                    Slider(value: $sliderValue,in: sliderRange){ editing in
                        isDraggingSlider = editing
                        if !editing && isCorrectVoiceMessage {
                            voiceMessagePlayer.seek(to: sliderValue)
                        }
                    }
                        .tint(.gray)
                    if playBackState == .stopped {
                        Text(item.audioDurationString)
                            .foregroundStyle(.gray)
                    }else{
                        Text(playBackTime)
                            .foregroundStyle(.gray)
                    }
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
            .onReceive(voiceMessagePlayer.$playState) { state in
                observePlayBackState(state)
            }
            .onReceive(voiceMessagePlayer.$currentTime) { currentTime in
                guard voiceMessagePlayer.currentUrl?.absoluteString == item.audioUrl else { return }
                listen(to: currentTime)
            }
        }
    }
    private func playButton() -> some View {
        Button{
            handlePlayVoiceMessage()
        }label: {
            Image(systemName: playBackState.icon)
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

extension BubbleAudioView {
    private func handlePlayVoiceMessage(){
        if playBackState == .stopped || playBackState == .paused {
            guard let audioUrl = item.audioUrl , let voiceMessageUrl = URL(string: audioUrl) else { return }
            voiceMessagePlayer.playAudio(from: voiceMessageUrl)
        } else {
            voiceMessagePlayer.pauseAudio()
        }
    }
    
    private func observePlayBackState(_ state: VoiceMessagePlayer.playBackState){
        switch state {
        case .stopped:
            playBackState = .stopped
            sliderValue = 0
        case .playing, .paused:
            if isCorrectVoiceMessage {
                playBackState = state
            }
        }
    }
    
    private func listen(to currentTime: CMTime){
        guard !isDraggingSlider else { return }
        playBackTime = currentTime.seconds.formatElapsedTime
        sliderValue = currentTime.seconds
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
