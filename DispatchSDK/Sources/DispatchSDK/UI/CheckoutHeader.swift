import SwiftUI

internal struct CheckoutHeader: View {
    @Preference(\.theme) var theme
    let logo: Image?
    let onLockButtonTapped: () -> Void
    
    var body: some View {
        ZStack {
            AsyncSVGView(url: URL(string: "https://bevelpr.com/images/bevel-logo-dark.svg")!)
            HStack {
                Button(action: {
                    withAnimation(.interactiveSpring) {
                        theme = theme.toggle()
                    }
                }) {
                    Image(systemName: theme.mode == .light ? "moon.fill" : "sun.max.fill")
                        .tint(.orange)
                }
                Button(action: {
                    withAnimation(.interactiveSpring) {
                        theme = theme.cycleStyle()
                    }
                }) {
                    Image(systemName: "arrow.3.trianglepath")
                        .tint(.orange)
                }

                Spacer()
                Button(action: {
                    onLockButtonTapped()
                }) {
                    Icons.lock.tint(.dispatchLightGray)
                }
            }
        }
        .padding(.horizontal)
    }
}
