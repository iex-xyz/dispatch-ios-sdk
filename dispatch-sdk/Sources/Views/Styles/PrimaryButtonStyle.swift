import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.theme) var theme
    @Environment(\.isEnabled) var isEnabled
    var isLoading: Bool
    var foregroundColor: Color
    var backgroundColor: Color
    var isFullWidth: Bool
    
    init(
        isLoading: Bool,
        foregroundColor: Color = .primary,
        backgroundColor: Color = Color(UIColor.systemBackground),
        isFullWidth: Bool = true
    ) {
        self.isLoading = isLoading
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.isFullWidth = isFullWidth
    }

    func makeBody(configuration: Configuration) -> some View {
        Group  {
            if isLoading {
                ProgressView()
                    .progressViewStyle(StrokedCircularProgressViewStyle())
            } else {
                configuration
                    .label
                    .font(.headline.bold())

            }
        }
        .foregroundColor(isLoading || !isEnabled ? .gray : foregroundColor)
        .padding(.horizontal)
        .frame(height: 44)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .background(!isEnabled ? Color.gray : backgroundColor)
        .cornerRadius(cornerRadius(for: theme.inputStyle))
        .opacity(configuration.isPressed ? 0.5 : 1)
        .animation(.easeInOut, value: configuration.isPressed)
        .disabled(!isEnabled)
        .scaleEffect(configuration.isPressed ? 0.975 : 1)
        .animation(.interactiveSpring, value: configuration.isPressed)
        .animation(.interactiveSpring, value: isLoading)
    }
    
    private func cornerRadius(for style: Style?) -> CGFloat {
        switch style {
        case .round:
            return 30
        case .soft:
            return 10
        case .sharp:
            return 0
        default:
            return 5
        }
    }
}


struct PrimaryButtonStyle_Preview: PreviewProvider {
    static let round = Theme.round
    static let soft = Theme.soft
    static let sharp = Theme.sharp

    static var previews: some View {
        VStack {
            VStack {
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: false,
                        backgroundColor: .blue,
                        isFullWidth: true
                    )
                )
                .environment(\.theme, soft)
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: true,
                        foregroundColor: .white,
                        backgroundColor: .blue,
                        isFullWidth: true
                    )
                )
                .environment(\.theme, soft)
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: false,
                        foregroundColor: .white,
                        backgroundColor: .blue,
                        isFullWidth: true
                    )
                )
                .environment(\.theme, soft)
            }
            .frame(maxWidth: .infinity)
            .padding()
            VStack {
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: false,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                .environment(\.theme, round)
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: true,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                .environment(\.theme, round)
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: false,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                .environment(\.theme, round)
            }
            .frame(maxWidth: .infinity)
            .padding()
            VStack {
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: false,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                .environment(\.theme, sharp)
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: true,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                .environment(\.theme, sharp)
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        isLoading: false,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                .environment(\.theme, sharp)
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .previewDevice("iPhone 12")
        
    }
}
