//
//  AudioPlayer.swift
//  Example
//
//  Created by Yesh Chandiramani (Dispatch) on 5/31/24.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var isLooping = true
    var timer: Timer?
    
    override init() {
        super.init()
        loadAudio()
    }
    
    func loadAudio() {
        if let path = Bundle.main.path(forResource: "song", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                try AVAudioSession.sharedInstance().setCategory(.playback)
                player?.delegate = self
                player?.prepareToPlay()
                updateLoopingState()
            } catch {
                print("Error loading audio file: \(error)")
            }
        }
    }
    
    func playPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            stopTimer()
        } else {
            player.play()
            startTimer()
        }
        isPlaying = player.isPlaying
    }
    
    func rewind() {
        guard let player = player else { return }
        player.currentTime -= 15
        currentTime = player.currentTime
    }
    
    func fastForward() {
        guard let player = player else { return }
        player.currentTime += 15
        currentTime = player.currentTime
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateCurrentTime()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateCurrentTime() {
        currentTime = player?.currentTime ?? 0
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isLooping {
            player.currentTime = 0
            player.play()
            isPlaying = true
            startTimer()
        } else {
            stopTimer()
            isPlaying = false
            currentTime = 0
        }
    }
    
    func toggleLooping() {
        isLooping.toggle()
        updateLoopingState()
    }
    
    private func updateLoopingState() {
        if isLooping {
            player?.numberOfLoops = -1  // Loop indefinitely
        } else {
            player?.numberOfLoops = 0  // No looping
        }
    }
    
    deinit {
        stopTimer()
    }
}
