//
//  AudioREcorderService.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 08/10/24.
//

import Foundation
import AVFoundation
import Combine

final class AudioRecorderService { 
    private var audioRecorder : AVAudioRecorder?
    private(set) var isRecording : Bool = false
    private var startTime : Date?
    private var timer : AnyCancellable?
    private var elapsedTime : TimeInterval = 0
    func startRecording() {
        // record the audio
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.overrideOutputAudioPort(.speaker)
            try audioSession.setActive(true)
        }catch{
            print("Voice recording failed")
        }
        // setup in the directory
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = Date().toString(format: "dd-MM-YY 'at' HH:MM:ss") + ".m4a"
        let audioFileURL = documentPath.appendingPathComponent(audioFileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        // if all good then do all this
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
            startTime = Date()
            startTimer()
        }catch{
            print("Voice recording failed AV Audio recorder")
        }
    }
    
    func stopRecording(completion : ((_ audioUrl: URL?,_ audioDuration: TimeInterval) -> Void)? = nil) {
        // if it is recording then i should come to stop else not
        guard isRecording else {return}
        let audioDuration = elapsedTime
        audioRecorder?.stop()
        isRecording = false
        timer?.cancel()
        elapsedTime = 0
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            guard let audioUrl = audioRecorder?.url else {return}
            completion?(audioUrl,audioDuration)
        }catch{
            print("Voice recording failed in stop recording")
        }
    }
    
    func tearDown() {
        let fileManager = FileManager.default
        let folder = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderContent = try! fileManager.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil)
        deleteRecordings(folderContent)
    }
    
    private func deleteRecordings(_ urls: [URL]){
        for url in urls{
            deleteRecording(at: url)
        }
    }
    
    private func deleteRecording(at fileUrl: URL){
        do{
            try FileManager.default.removeItem(at: fileUrl)
        }catch{
            print("Failed to delete the recording")
        }
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
            guard let startTime = self?.startTime else {return}
            self?.elapsedTime = Date().timeIntervalSince(startTime)
        })
    }
}
