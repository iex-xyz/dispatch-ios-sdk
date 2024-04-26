import SwiftUI

struct MerchantSecurityTag: View {
    @Preference(\.theme) var theme

    let domain: String
    let tapHandler: () -> Void
    
    var body: some View {
        Button(action: {
            tapHandler()
        }) {
            HStack {
                Image(systemName: "lock.circle") // TODO: Dotted version where supported
                    .foregroundStyle(Color.dispatchBlue)
                Text(domain)
                    .foregroundStyle(.primary)
            }
            .padding(4)
            .background(Colors.secondaryBackgroundColor)
            .clipShape(Capsule())
        }
    }
}

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
                Button(action: {
                    onCloseButtonTapped()
                }) {
                    Icons.close
                }
            }
        }
        .padding(.horizontal)
    }
}
