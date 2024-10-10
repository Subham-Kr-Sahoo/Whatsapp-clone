//
//  MediaPlayerView.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 05/10/24.
//

import SwiftUI
import AVKit

struct MediaPlayerView: View {
    let player : AVPlayer
    let dismiss : () -> Void
    var body: some View {
        VideoPlayer(player: player)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay(alignment:.topLeading){
                cancelButton()
            }
            .onAppear {
                player.play()
            }
    }
    private func cancelButton() -> some View {
        Button{
            dismiss()
        }label: {
            Image(systemName: "xmark")
                .scaledToFit()
                .imageScale(.large)
                .padding(10)
                .foregroundStyle(.whatsAppBlack)
                .background(Color.whatsAppBlack.opacity(0.2))
                .clipShape(Circle())
                .padding(2)
                .bold()
        }
    }
}

