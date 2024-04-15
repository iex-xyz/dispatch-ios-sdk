import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    let theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline) {
            configuration.label
        }
        .scaleEffect(configuration.isPressed ? 0.975 : 1)
        .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}




struct SecondaryButtonStyle_Preview: PreviewProvider {
    static let round = Theme.round
    static let soft = Theme.soft
    static let sharp = Theme.sharp

    static var previews: some View {
        VStack {
            VStack(spacing: 24) {
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    SecondaryButtonStyle(
                        theme: soft
                    )
                )
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    SecondaryButtonStyle(
                        theme: sharp
                    )
                )
                Button(action: {}) {
                    Text("Continue to accept the terns of service on a multiline label")
                }
                .buttonStyle(
                    SecondaryButtonStyle(
                        theme: round
                    )
                )
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .previewDevice("iPhone 12")
        
    }
}
