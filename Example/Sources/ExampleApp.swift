import SwiftUI

@main
struct ExampleApp: App {
    @StateObject private var sharedAudioPlayer = AudioPlayer()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MusicPlayerView()
                    .environmentObject(sharedAudioPlayer)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                sharedAudioPlayer.loadAudio()
            }
        }
    }
}
