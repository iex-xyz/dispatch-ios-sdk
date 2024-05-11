import UIKit
import SwiftUI

@available(iOS 15.0, *)
struct PhoneNumberTextField: UIViewRepresentable {
    @Preference(\.theme) var theme
    @Binding var text: String
    @Binding var country: Country

    var isValid: Bool
    var isFocused: Bool
    static var fallbackPlaceholder: String = "+1 (123) 456-7890"

    func makeUIView(context: Context) -> UITextField {
        let textField = PaddedTextField(theme: theme)
        textField.keyboardType = .phonePad
        textField.delegate = context.coordinator
        textField.layer.borderWidth = 2
        textField.layer.borderColor = Colors.borderGray.cgColor
        textField.backgroundColor = UIColor(Colors.controlBackground)
        textField.keyboardType = .numberPad
        textField.textContentType = .telephoneNumber
        textField.placeholder = PhoneNumberValidator.rules(for: country)?.placeholder ?? Self.fallbackPlaceholder
        switch theme.inputStyle {
        case .round, .rounded:
            textField.layer.cornerRadius = theme.cornerRadius
        case .sharp:
            textField.layer.cornerRadius = theme.cornerRadius
        case .soft:
            textField.layer.cornerRadius = theme.cornerRadius
        }
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.placeholder = PhoneNumberValidator.rules(for: country)?.placeholder ?? Self.fallbackPlaceholder

        context.coordinator.parent = self
        
        if isFocused {
            uiView.layer.borderColor = Color.dispatchBlue.cgColor
        } else if !isValid {
            uiView.layer.borderColor = Color.dispatchRed.cgColor
        } else {
            uiView.layer.borderColor = Colors.borderGray.cgColor
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, country: $country)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PhoneNumberTextField
        @Binding var country: Country

        init(_ textField: PhoneNumberTextField, country: Binding<Country>) {
            self.parent = textField
            self._country = country
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isFocused = true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isFocused = false
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let fullText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            textField.text = format(for: fullText)
            parent.text = textField.text ?? ""
            return false
        }

        private func format(for number: String) -> String {
            var digits = number.filter { $0.isNumber }
            let rules = PhoneNumberValidator.rules(for: country)
            let mask = rules?.mask ?? "+# (###) ###-####"

            if !digits.hasPrefix(rules?.countryCode ?? "1") {
                digits = (rules?.countryCode ?? "1") + digits
            }

            var result = ""
            var index = digits.startIndex

            for ch in mask where index < digits.endIndex {
                if ch == "#" {
                    result.append(digits[index])
                    index = digits.index(after: index)
                } else {
                    result.append(ch)
                }
            }

            return result
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    @State var phone: String = ""
    @State var country: Country = .unitedStates
    return VStack {
        PhoneNumberTextField(
            text: $phone,
            country: $country,
            isValid: false,
            isFocused: true
        )
        .frame(height: 44)
        PhoneNumberTextField(
            text: $phone,
            country: $country,
            isValid: true,
            isFocused: false
        )
        .frame(height: 44)
        PhoneNumberTextField(
            text: $phone,
            country: $country,
            isValid: false,
            isFocused: false
        )
    }
    .padding()
}
