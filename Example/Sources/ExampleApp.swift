import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack(spacing: 30) {
                    Spacer()
                    Text("Tap to launch your desired Dispatch SDK experience")
                        .padding()
                    NavigationLink(destination: ExampleAppContentView().navigationTitle("Example Dispatch SDK Experience")) {
                        Text("Example App")
                    }
                    NavigationLink(destination: MusicAppContentView().navigationTitle("Music App Experience")) {
                        Text("Music App")
                    }
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
