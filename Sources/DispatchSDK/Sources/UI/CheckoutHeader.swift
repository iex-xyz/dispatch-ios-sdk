import SwiftUI

internal struct CheckoutHeader: View {
    @Preference(\.theme) var theme
    let logo: Image?
    let domain: String
    let onLockButtonTapped: () -> Void
    let onCloseButtonTapped: () -> Void

    var body: some View {
        ZStack {
//            AsyncSVGView(url: URL(string: "https://bevelpr.com/images/bevel-logo-dark.svg")!)
            MerchantSecurityTag(domain: domain, tapHandler: onLockButtonTapped)
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
                CloseButton {
                    onCloseButtonTapped()
                }
            }
        }
        .padding(.horizontal)
    }
}
