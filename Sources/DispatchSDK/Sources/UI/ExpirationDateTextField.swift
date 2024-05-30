import UIKit
import SwiftUI

@available(iOS 15.0, *)
struct ExpirationDateTextField: UIViewRepresentable {
    @Preference(\.theme) var theme
    @Binding var text: String
    var isValid: Bool
    var isFocused: Bool = false
    
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
        case .round, .rounded:
            textField.layer.cornerRadius = 24
        case .sharp:
            textField.layer.cornerRadius = 0
        case .soft:
            textField.layer.cornerRadius = 4
        }
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        DispatchQueue.main.async {
            uiView.text = self.text
            if self.isFocused {
                uiView.layer.borderColor = Color.dispatchBlue.cgColor
            } else if !self.isValid {
                uiView.layer.borderColor = Color.dispatchRed.cgColor
            } else {
                uiView.layer.borderColor = Colors.borderGray.cgColor
            }
        }
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
            
            if cleaned.count >= 1 {
                if cleaned.count == 1, let month = Int(cleaned) {
                    if month > 1 {
                        formatted = "0\(cleaned)/"
                    } else {
                        formatted = cleaned
                    }
                } else {
                    let month = String(cleaned.prefix(2))
                    formatted = month + "/"
                    
                    if cleaned.count > 2 {
                        formatted += String(cleaned.suffix(cleaned.count - 2))
                    }
                }
            }
            
            formatted = String(formatted.prefix(5)) // Limit to MM/YY format
            
            textField.text = formatted
            parent.text = formatted
            return false // We've handled the text input manually
            
            //            let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            //            if string == "" { // Allow deletion
            //                parent.text = currentText
            //                return true
            //            }
            //            let cleaned = currentText.filter { "0123456789".contains($0) }
            //            var formatted = ""
            //
            //            if cleaned.count >= 1 {
            //                let month = String(cleaned.prefix(2))
            //                formatted += month
            //                if Int(month) ?? 0 > 12 {
            //                    formatted = "12"
            //                }
            //                if cleaned.count >= 3 {
            //                    formatted += "/"
            //                    formatted += String(cleaned.suffix(cleaned.count - 2))
            //                }
            //            }
            //            formatted = String(formatted.prefix(5)) // Limit to MM/YY format
            //
            //            textField.text = formatted
            //            parent.text = formatted
            //            return false // We've handled the text input manually
        }
    }
}
