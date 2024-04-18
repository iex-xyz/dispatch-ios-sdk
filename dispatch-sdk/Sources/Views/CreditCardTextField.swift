import UIKit
import SwiftUI

enum CreditCardType: CaseIterable {
    case visa
    case masterCard
    case americanExpress
    case discover
    case dinersClub
    case jcb

    var format: String {
        switch self {
        case .visa, .masterCard, .discover:
            return "#### #### #### ####"
        case .americanExpress:
            return "#### ###### #####"
        case .dinersClub:
            return "#### ###### ####"
        case .jcb:
            // NOTE: JCB cards can also have 15-16 digits like Diners.
            return "#### #### #### ####"
        }
    }

    static func detect(from number: String) -> CreditCardType? {
        let formattedNumber = number.filter { $0.isWholeNumber }
        
        // Match card type based on number prefixes
        if formattedNumber.hasPrefix("4") {
            return .visa
        } else if formattedNumber.hasPrefix("5") {
            return .masterCard
        } else if formattedNumber.hasPrefix("34") || formattedNumber.hasPrefix("37") {
            return .americanExpress
        } else if formattedNumber.hasPrefix("6") {
            return .discover
        } else if formattedNumber.hasPrefix("3") {
            return .dinersClub
        } else if formattedNumber.hasPrefix("35") {
            return .jcb
        }
        return nil
    }
}


extension String {
    func formatAsCreditCard() -> String {

        guard let cardType = CreditCardType.detect(from: self) else {
            return self // Return original if no card type matches
        }
        let mask = cardType.format
        let digits = self.filter { $0.isNumber }
        var formattedString = ""
        var digitIndex = 0

        for char in mask {
            if digitIndex >= digits.count {
                break
            }
            if char == "#" {
                formattedString.append(digits[digitIndex])
                digitIndex += 1
            } else {
                formattedString.append(char)
            }
        }

        print("formatAsCreditCard: original text = \(formattedString)")
        return formattedString
    }
    
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }

    subscript(range: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(startIndex, offsetBy: range.upperBound - range.lowerBound)
        return String(self[startIndex..<endIndex])
    }
}


extension Character {
    var isNumber: Bool {
        return isASCII && "0"..."9" ~= self
    }
}

struct CreditCardTextField: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        textField.borderStyle = .line
        
        if textField.text != text {
            textField.text = text
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
