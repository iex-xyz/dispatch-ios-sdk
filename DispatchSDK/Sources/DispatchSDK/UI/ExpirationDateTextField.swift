import UIKit
import SwiftUI

struct ExpirationDateTextField: UIViewRepresentable {
    @Preference(\.theme) var theme
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
        let textField = PaddedTextField()
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        textField.placeholder = "MM/YY"
        textField.delegate = context.coordinator
        textField.layer.borderWidth = 2
        textField.layer.borderColor = Colors.borderGray.cgColor
        textField.backgroundColor = UIColor(Colors.controlBackground)
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
        var parent: ExpirationDateTextField

        init(_ textField: ExpirationDateTextField) {
            self.parent = textField
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            if string == "" { // Allow deletion
                parent.text = currentText
                return true
            }
            let cleaned = currentText.filter { "0123456789".contains($0) }
            var formatted = ""
            
            for (index, character) in cleaned.enumerated() {
                if index == 2 {
                    formatted.append("/")
                }
                if index > 4 { break } // Stops adding characters after "MM/YY"
                formatted.append(character)
            }
            
            textField.text = formatted
            parent.text = formatted
            return false // We've handled the text input manually
        }
    }
}
