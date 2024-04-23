import UIKit
import SwiftUI

struct PhoneNumberTextField: UIViewRepresentable {
    @Preference(\.theme) var theme
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
        let textField = PaddedTextField()
        textField.keyboardType = .phonePad
        textField.delegate = context.coordinator
        textField.layer.borderWidth = 2
        textField.layer.borderColor = Colors.borderGray.cgColor
        textField.backgroundColor = UIColor(Colors.controlBackground)
        textField.keyboardType = .numberPad
        textField.textContentType = .telephoneNumber
        switch theme.inputStyle {
        case .round:
            textField.layer.cornerRadius = 24
        case .sharp:
            textField.layer.cornerRadius = 0
        case .soft:
            textField.layer.cornerRadius = 4
        }
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PhoneNumberTextField

        init(_ textField: PhoneNumberTextField) {
            self.parent = textField
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let fullText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            textField.text = format(for: fullText)
            parent.text = textField.text ?? ""
            return false
        }

        private func format(for number: String) -> String {
            let digits = number.filter { $0.isNumber }
            let mask = "+# (###) ###-####"

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

#Preview {
    @State var phone: String = ""
    return PhoneNumberTextField(text: $phone)
        .frame(height: 44)
}
