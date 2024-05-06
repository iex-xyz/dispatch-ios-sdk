import SwiftUI

fileprivate extension Theme {
    var validationAlignment: Alignment {
        switch self.inputStyle {
        case .round, .rounded:
            return .trailing
        case .soft, .sharp:
            return .topTrailing
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct ThemeTextFieldStyle: TextFieldStyle {
    @Preference(\.theme) var theme

    var isFocused: Bool
    var isValid: Bool
    
    var labelText: String? = nil
    
    func _body(configuration: TextField<_Label>) -> some View {
        ZStack(alignment: theme.validationAlignment) {
            VStack(alignment: .leading) {
                if let labelText {
                    Text(labelText)
//                        .foregroundStyle(isValid ? .primary : Color.dispatchRed)
                        .font(.footnote)
                        .frame(alignment: .leading)
                }
                configuration
                    .padding(.horizontal, 16)
                    .foregroundStyle(.primary)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius(for: theme.inputStyle), style: .continuous)
                            .stroke(borderColor, lineWidth: 2)
                    )
                    .background(
                        RoundedRectangle(
                            cornerRadius: cornerRadius(for: theme.inputStyle),
                            style: .continuous
                        )
                        .fill(
                            Colors.controlBackground
                        )
                    )
            }
            
            if !isValid {
                switch theme.inputStyle {
                case .round, .rounded:
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundStyle(.red)
                        .padding(.trailing)
                case .sharp:
                    Rectangle()
                        .fill(.red)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Image(systemName: "exclamationmark")
                                .resizable()
                                .scaledToFit()
                                .padding(2)
                                .foregroundStyle(.white)
                        )
                case .soft:
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.red)
                        .frame(width: 16, height: 16)
                        .overlay(
                            Image(systemName: "exclamationmark")
                                .resizable()
                                .scaledToFit()
                                .padding(2)
                                .foregroundStyle(.white)
                        )
                }
            }
        }
        .colorScheme(theme.colorScheme)
    }
    
    private var borderColor: Color {
        if !isValid {
            return .red
        } else if isFocused {
            return Color.dispatchBlue
        } else {
            return Colors.borderGray
        }
    }
    
    private func cornerRadius(for style: Style?) -> CGFloat {
        switch style {
        case .round, .rounded:
            return 30
        case .soft:
            return 4
        case .sharp:
            return 0
        default:
            return 0
        }
    }
}

struct ThemeTextFieldStyle_Preview: PreviewProvider {
    static var previews: some View {
        // Example Theme, replace with your actual theme values.
        VStack(spacing: 24) {
            VStack {
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: false,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: true,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("Typing")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: true,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("Value")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: false,
                            isValid: false
                        )
                    )
            }
            .environment(\.theme, .sharp)
            VStack {
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: false,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: true,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("Typing")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: true,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("Value")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: false,
                            isValid: false
                        )
                    )
            }
            .environment(\.theme, .sharp)
            VStack {
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: false,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: true,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("Typing")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: true,
                            isValid: true
                        )
                    )
                TextField("Value", text: .constant("Value")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: false,
                            isValid: false
                        )
                    )
            }
            .environment(\.theme, .round)
        }
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.all)
        .previewDevice("iPhone 12")
    }
}
