import SwiftUI
import DispatchSDK

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                Button(action: {
                    DispatchSDK.shared.present()
                }) {
                    Text("Buy Now")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
