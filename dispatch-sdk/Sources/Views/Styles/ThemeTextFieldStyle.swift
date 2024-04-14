import SwiftUI

fileprivate extension Theme {
    var validationAlignment: Alignment {
        switch self.inputStyle {
        case .round:
            return .trailing
        case .soft, .sharp:
            return .topTrailing
        }
    }
}

struct ThemeTextFieldStyle: TextFieldStyle {
    @Binding var isFocused: Bool
    @Binding var isValid: Bool
    let theme: Theme
    
    func _body(configuration: TextField<_Label>) -> some View {
        ZStack(alignment: theme.validationAlignment) {
            configuration
                .padding(.horizontal, 16)
                .foregroundStyle(.primary)
                .tint(.primary)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius(for: theme.inputStyle), style: .continuous)
                        .stroke(borderColor, lineWidth: 2)
                )
            
            if !isValid {
                switch theme.inputStyle {
                case .round:
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
    }
    
    private var borderColor: Color {
        if !isValid {
            return .red
        } else if isFocused {
            return .blue
        } else {
            return Color(hex: "#E8E8E8")
        }
    }
    
    private func cornerRadius(for style: Style?) -> CGFloat {
        switch style {
        case .round:
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
    static let soft = Theme(inputStyle: .soft)
    static let sharp = Theme(inputStyle: .sharp)
    static let round = Theme(inputStyle: .round)
    static var previews: some View {
        // Example Theme, replace with your actual theme values.
        VStack(spacing: 24) {
            VStack {
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(false), 
                            isValid: .constant(true), 
                            theme: soft
                        )
                    )
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(true), 
                            isValid: .constant(true), 
                            theme: soft
                        )
                    )
                TextField("Value", text: .constant("Typing")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(true), 
                            isValid: .constant(true), 
                            theme: soft
                        )
                    )
                TextField("Value", text: .constant("Value")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(false), 
                            isValid: .constant(false), 
                            theme: soft
                        )
                    )
            }
            VStack {
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(false), 
                            isValid: .constant(true), 
                            theme: sharp
                        )
                    )
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(true), 
                            isValid: .constant(true), 
                            theme: sharp
                        )
                    )
                TextField("Value", text: .constant("Typing")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(true), 
                            isValid: .constant(true), 
                            theme: sharp
                        )
                    )
                TextField("Value", text: .constant("Value")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(false), 
                            isValid: .constant(false), 
                            theme: sharp
                        )
                    )
            }
            VStack {
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(false), 
                            isValid: .constant(true), 
                            theme: round
                        )
                    )
                TextField("Value", text: .constant("")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(true), 
                            isValid: .constant(true), 
                            theme: round
                        )
                    )
                TextField("Value", text: .constant("Typing")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(true), 
                            isValid: .constant(true), 
                            theme: round
                        )
                    )
                TextField("Value", text: .constant("Value")) 
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: .constant(false), 
                            isValid: .constant(false), 
                            theme: round
                        )
                    )
            }
        }
        .padding(.horizontal)
        .edgesIgnoringSafeArea(.all)
        .background(Color.white)
        .previewDevice("iPhone 12")
    }
}
