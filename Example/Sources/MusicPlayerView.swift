//
//  MusicPlayerView.swift
//  Example
//
//  Created by Yesh Chandiramani (Dispatch) on 5/29/24.
//

import SwiftUI

struct MusicPlayerView: View {
    @EnvironmentObject private var audioPlayer: AudioPlayer
    
    let orangeColor = Color(red: 255/255, green: 93/255, blue: 36/255)
    
    var body: some View {
        VStack {
            HStack {
                Text("music")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: MerchView()) {
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
                            .foregroundColor(orangeColor)
                    }
                    .id(audioPlayer.isPlaying)
                }
                .padding()
                .background(Color.black.opacity(0.6))
                
                
                Slider(value: $audioPlayer.currentTime, in: 0...(audioPlayer.player?.duration ?? 1), onEditingChanged: { _ in
                    audioPlayer.player?.currentTime = audioPlayer.currentTime
                })
                .accentColor(orangeColor)
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
                        audioPlayer.toggleLooping()
                    }) {
                        Image(systemName: "repeat")
                            .foregroundColor(audioPlayer.isLooping ? orangeColor : .white)
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
    }
}

#Preview {
    MusicPlayerView()
        .environmentObject(AudioPlayer())
}
