import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MusicAppContentView()
            }.background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}
