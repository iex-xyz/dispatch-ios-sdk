import SwiftUI

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .navigationTitle("Dispatch SDK")
            }
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
