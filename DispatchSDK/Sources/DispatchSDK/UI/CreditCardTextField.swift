import UIKit
import SwiftUI

struct CreditCardTextField: UIViewRepresentable {
    @Preference(\.theme) var theme
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = PaddedTextField()
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        textField.layer.borderWidth = 2
        textField.layer.borderColor = Colors.borderGray.cgColor
        textField.backgroundColor = UIColor(Colors.controlBackground)
        textField.keyboardType = .numberPad
        textField.textContentType = .creditCardNumber
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
        print("updateUIView: current text = \(uiView.text ?? "nil"), new text = \(text)")
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CreditCardTextField
        
        init(_ textField: CreditCardTextField) {
            self.parent = textField
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            let formattedText = newText.formatAsCreditCard()
            
            print("Formatted: \(formattedText)")
            textField.text = formattedText
            parent.text = formattedText // Update the SwiftUI state
            
            return false // We've handled the text input manually
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.layer.borderColor = Color.dispatchBlue.cgColor
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            textField.layer.borderColor = Colors.borderGray.cgColor
        }
    }
}

#Preview {
    @State var creditCardNumber = ""
    return VStack {
        CreditCardTextField(text: $creditCardNumber)
            .padding(.horizontal)
            .frame(height: 44)
//            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            .padding()

        Text("Entered Number: \(creditCardNumber)")
            .padding()
    }

}
