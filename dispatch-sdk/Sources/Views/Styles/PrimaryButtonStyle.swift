import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let theme: Theme
    var isLoading: Bool
    var isDisabled: Bool
    var foregroundColor: Color
    var backgroundColor: Color
    var isFullWidth: Bool
    
    init(
        theme: Theme,
        isLoading: Bool,
        isDisabled: Bool,
        foregroundColor: Color,
        backgroundColor: Color,
        isFullWidth: Bool = true
    ) {
        self.theme = theme
        self.isLoading = isLoading
        self.isDisabled = isDisabled
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
        .foregroundColor(isLoading || isDisabled ? .gray : foregroundColor)
        .padding(.horizontal)
        .frame(height: 44)
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .background(isDisabled ? Color.gray : backgroundColor)
        .cornerRadius(cornerRadius(for: theme.inputStyle))
        .opacity(configuration.isPressed ? 0.5 : 1)
        .animation(.easeInOut, value: configuration.isPressed)
        .disabled(isDisabled)
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
    static let round = Theme(inputStyle: .round)
    static let soft = Theme(inputStyle: .soft)
    static let sharp = Theme(inputStyle: .sharp)

    static var previews: some View {
        VStack {
            VStack {
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: soft,
                        isLoading: false,
                        isDisabled: false,
                        foregroundColor: .white,
                        backgroundColor: .blue,
                        isFullWidth: true
                    )
                )
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: soft,
                        isLoading: true,
                        isDisabled: false,
                        foregroundColor: .white,
                        backgroundColor: .blue,
                        isFullWidth: true
                    )
                )
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: soft,
                        isLoading: false,
                        isDisabled: true,
                        foregroundColor: .white,
                        backgroundColor: .blue,
                        isFullWidth: true
                    )
                )
            }
            .frame(maxWidth: .infinity)
            .padding()
            VStack {
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: round,
                        isLoading: false,
                        isDisabled: false,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: round,
                        isLoading: true,
                        isDisabled: false,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: round,
                        isLoading: false,
                        isDisabled: true,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
            }
            .frame(maxWidth: .infinity)
            .padding()
            VStack {
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: sharp,
                        isLoading: false,
                        isDisabled: false,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: sharp,
                        isLoading: true,
                        isDisabled: false,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(
                    PrimaryButtonStyle(
                        theme: sharp,
                        isLoading: false,
                        isDisabled: true,
                        foregroundColor: .white,
                        backgroundColor: .blue
                    )
                )
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .previewDevice("iPhone 12")
        
    }
}
