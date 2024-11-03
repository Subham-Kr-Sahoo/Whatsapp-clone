//
//  voiceMessagePlayer.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 30/10/24.
//

import Foundation
import AVFoundation

final class VoiceMessagePlayer : ObservableObject {
    private var player: AVPlayer?
    private(set) var currentUrl: URL?
    private var playerItem: AVPlayerItem?
    @Published private(set) var playState = playBackState.stopped
    @Published private(set) var currentTime = CMTime.zero
    private var currentTimeObserver : Any?
    
    deinit {
        tearDown()
    }
    
    func playAudio(from url: URL) {
        // plays a resumed voice message 
        if let currentUrl = currentUrl , currentUrl == url {
            resumePlaying()
        }else{
            // plays a new voice message from beginning
            stopAudio()
            currentUrl = url
            let playerItem = AVPlayerItem(url: url)
            self.playerItem = playerItem
            player = AVPlayer(playerItem: playerItem)
            player?.play()
            playState = .playing
            observeCurrentPlayerTime()
            observeEndOfPlayBack()
        }
    }
    
    // for pausing the audio
    func pauseAudio() {
        player?.pause()
        playState = .paused
    }
    
    // for the drag gesture of the audio track
    func seek(to timeInterval : TimeInterval) {
        guard let player = player else { return }
        let targetTime = CMTime(seconds: timeInterval, preferredTimescale: 1)
        player.seek(to: targetTime)
    }
    
    // for time track
    private func observeCurrentPlayerTime() {
        currentTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main){ [weak self] time in
            self?.currentTime = time
        }
    }
    
    // to check the audio reached the end or what ??
    private func observeEndOfPlayBack(){
        NotificationCenter.default.addObserver(forName: AVPlayerItem.didPlayToEndTimeNotification, object: player?.currentItem, queue: .main){[weak self] _ in
            self?.stopAudio()
        }
    }
    
    // stopping the audio
    private func stopAudio() {
        player?.pause()
        player?.seek(to: .zero)
        playState = .stopped
        currentTime = .zero
    }
    
    // resuming the audio
    private func resumePlaying() {
        if playState == .paused || playState == .stopped {
            player?.play()
            playState = .playing
        }
    }
    
    // to remove all the observers
    private func removeObservers() {
        guard let currentTimeObserver else { return }
        player?.removeTimeObserver(currentTimeObserver)
        self.currentTimeObserver = nil
    }
    
    // finally tearing down the whole system
    private func tearDown(){
        removeObservers()
        player = nil
        playerItem = nil
        currentUrl = nil
    }
    
}

extension VoiceMessagePlayer {
    enum playBackState {
        case stopped,playing,paused
        var icon : String {
            return self == .playing ? "pause.fill" : "play.fill"
        }
    }
}
