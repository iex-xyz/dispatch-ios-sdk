import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MusicPlayerView()
            }.background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}
