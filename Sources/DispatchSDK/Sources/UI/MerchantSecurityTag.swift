import SwiftUI

@available(iOS 15.0, *)
struct MerchantSecurityTag: View {
    @Preference(\.theme) var theme

    let tapHandler: () -> Void
    
    var body: some View {
        Button(action: {
            tapHandler()
        }) {
            HStack {
                Image(systemName: "lock.circle") // TODO: Dotted version from figma?
                    .foregroundStyle(Color.dispatchBlue)
            }
            .padding(4)
            .background(Colors.secondaryBackgroundColor)
            .clipShape(Capsule())
        }
        .foregroundStyle(.primary)
        .colorScheme(theme.colorScheme)
    }
}

@available(iOS 15.0, *)
#Preview {
    MerchantSecurityTag(tapHandler: {})
}

// WIP: This still has some tweaks before it can work well in the MerchantSecurityTag
@available(iOS 15.0, *)
struct MarqueeText: View {
    let text: String
    @State private var textWidth: CGFloat = 0
    @State private var frameWidth: CGFloat = 0
    @State private var animate: Bool = false

    var body: some View {
        GeometryReader { geometry in
            Text(text)
                .lineLimit(1)
                .foregroundStyle(.primary)
                .background(GeometryReader { textGeometry in
                    Color.clear.onAppear {
                        self.textWidth = textGeometry.size.width
                        self.frameWidth = geometry.size.width
                        DispatchQueue.main.async {
                            self.animate = self.textWidth > self.frameWidth
                        }
                    }
                })
                .offset(x: animate ? -textWidth * 2 : 0)
                .animation(animate ? Animation.linear(duration: Double(textWidth) / 20).repeatForever(autoreverses: false) : nil, value: animate)
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    MarqueeText(text: "welcometothelodgewithalongname.com")
}
