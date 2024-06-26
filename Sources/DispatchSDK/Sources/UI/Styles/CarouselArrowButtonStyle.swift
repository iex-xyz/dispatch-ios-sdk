import SwiftUI

@available(iOS 15.0, *)
struct CarouselArrowButtonStyle: ButtonStyle {
    @Preference(\.theme) var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .frame(width: 32, height: 32)
            .foregroundStyle(Color.primary)
            .background(
                Circle()
                    .fill(theme.backgroundColor)
            )
            .overlay(
                Circle()
                    .stroke(Colors.borderGray)
            )
            .padding(12)
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .animation(.interactiveSpring, value: configuration.isPressed)

    }
}

@available(iOS 15.0, *)
#Preview {
    VStack {
        HStack {
            Button(action: {
            }) {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(CarouselArrowButtonStyle())
            Button(action: {
            }) {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(CarouselArrowButtonStyle())
        }
        .preferredColorScheme(.light)
        HStack {
            Button(action: {
            }) {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(CarouselArrowButtonStyle())
            .background(.red)
            Button(action: {
            }) {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(CarouselArrowButtonStyle())
            .background(.red)
        }
        .preferredColorScheme(.dark)
    }
}
