//
//  MusicAppContentView.swift
//  Example
//
//  Created by Yesh Chandiramani (Dispatch) on 5/29/24.
//

import SwiftUI
import DispatchSDK
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
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
        stopTimer()
        isPlaying = false
        currentTime = 0
        player.currentTime = 0
    }
    
    deinit {
        stopTimer()
    }
}

struct MusicAppContentView: View {
    @StateObject private var audioPlayer = AudioPlayer()
    
    var body: some View {
        VStack {
            HStack {
                Text("music")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button (action: {
                    let config: DispatchConfig = DispatchConfig(
                        applicationId: "64b86c02453510acde70250f",
                        environment: .demo,
                        merchantId: "merchant.co.dispatch.checkout",
                        orderCompletionCTA: "Back To Music"
                    )
                    DispatchSDK.shared.setup(using: config)
                    DispatchSDK.shared.present(with: .checkout("6658978ca433607696246daa"))
                }) {
                    Text("merch")
                        .foregroundColor(.gray)
                        .font(.title)
                }
            }
            .padding([.leading, .trailing])
            
            // Music card
            Image("albumCover")
                .resizable()
                .cornerRadius(10.0)
                .shadow(radius: 5)
                .aspectRatio(contentMode: .fit)
                .padding()
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Cosmic Heartbeat")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Nova Drift")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text("2024")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button(action: {
                        audioPlayer.playPause()
                    }) {
                        Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(red: 255/255, green: 93/255, blue: 36/255))
                    }
                }
                .padding()
                .background(Color.black.opacity(0.6))
                
                
                Slider(value: $audioPlayer.currentTime, in: 0...(audioPlayer.player?.duration ?? 1), onEditingChanged: { _ in
                    audioPlayer.player?.currentTime = audioPlayer.currentTime
                })
                .accentColor(Color(red: 255/255, green: 93/255, blue: 36/255))
                .padding([.leading, .trailing])
                
                HStack {
                    Button(action: {
                        audioPlayer.rewind()
                    }) {
                        Image(systemName: "gobackward.15")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                    Spacer()
                    Button(action: {
                        audioPlayer.fastForward()
                    }) {
                        Image(systemName: "goforward.15")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                .padding([.leading, .trailing])
            }
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            audioPlayer.loadAudio()
        }
    }
}

#Preview {
    MusicAppContentView()
}
