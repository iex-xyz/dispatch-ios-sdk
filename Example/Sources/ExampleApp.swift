import SwiftUI

@main
struct ExampleApp: App {
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
