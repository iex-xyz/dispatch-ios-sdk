import SwiftUI

struct CarouselArrowButtonStyle: ButtonStyle {
    @Preference(\.theme) var theme

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .frame(width: 32, height: 32)
            .foregroundStyle(Color.primary)
            .background(
                Circle()
                    .fill(Color(UIColor.systemBackground))
            )
            .overlay(
                Circle()
                    .stroke(Color(hex: "#E8E8E8"))
            )
            .padding(8)
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .animation(.interactiveSpring, value: configuration.isPressed)

    }
}

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
            Button(action: {
            }) {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(CarouselArrowButtonStyle())
        }
        .preferredColorScheme(.dark)
    }
}
