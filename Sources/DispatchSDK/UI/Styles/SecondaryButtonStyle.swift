import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    @Preference(\.theme) var theme

    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline) {
            configuration.label
                .font(.footnote.bold())
                .foregroundStyle(.primary)
        }
        .scaleEffect(configuration.isPressed ? 0.975 : 1)
        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
        .colorScheme(theme.colorScheme)
    }
}




#Preview {
    VStack {
        VStack(spacing: 24) {
            Button(action: {}) {
                Text("Continue")
            }
            .buttonStyle(
                SecondaryButtonStyle()
            )
            .environment(\.theme, .soft)
            Button(action: {}) {
                Text("Continue")
            }
            .buttonStyle(
                SecondaryButtonStyle()
            )
            .environment(\.theme, .sharp)
            
            Button(action: {}) {
                Text("Continue to accept the terns of service on a multiline label")
            }
            .buttonStyle(
                SecondaryButtonStyle()
            )
            .environment(\.theme, .round)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    .previewDevice("iPhone 12")
    
}
