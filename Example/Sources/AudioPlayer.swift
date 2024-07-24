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
    }

    func loadAudio() {
        if let path = Bundle.main.path(forResource: "song", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                try AVAudioSession.sharedInstance().setCategory(.playback)
                player?.delegate = self
                player?.prepareToPlay()
                player?.numberOfLoops = isLooping ? -1 : 0 // -1 is to set the loop infinitely until stopped
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
        isPlaying.toggle()
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
        if !isLooping {
            stopTimer()
            isPlaying = false
            currentTime = 0
            player.currentTime = 0
        }
    }
    
    func toggleLooping() {
        isLooping.toggle()
        player?.numberOfLoops = isLooping ? -1 : 0
    }
    
    deinit {
        stopTimer()
    }
}
