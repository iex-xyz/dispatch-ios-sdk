import SwiftUI

internal struct CheckoutHeader: View {
    @Preference(\.theme) var theme
    let logo: Image?
    
    var body: some View {
        ZStack {
            if let logo {
                logo
            } else {
                Text("TODO")
                    .font(.caption.bold())
                    .padding(8)
            }
            HStack {
                Button(action: {
                    theme = theme.toggle()
                }) {
                    Image(systemName: theme.mode == .light ? "moon.fill" : "sun.max.fill")
                        .tint(.orange)
                }
                Spacer()
                Icons.lock.tint(.dispatchLightGray)
            }
        }
    }
}
