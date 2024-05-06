import UIKit
import SwiftUI

class CardTypeUITextField: PaddedTextField {
    let cardImageView = UIImageView(image: Icons.Card.default)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardImageView.contentMode = .scaleAspectFit
        setRightView(cardImageView, padding: 48)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardImageView.frame.size = .init(width: 32, height: 16)
    }
}

struct CreditCardTextField: UIViewRepresentable {
    @Preference(\.theme) var theme
    @Binding var text: String
    var isValid: Bool
    var isFocused: Bool = false

    var cardIcon: UIImage? = Icons.Card.default

    func makeUIView(context: Context) -> CardTypeUITextField {
        let textField = CardTypeUITextField(frame: .zero)
        textField.keyboardType = .numberPad
        textField.delegate = context.coordinator
        textField.layer.borderWidth = 2
        textField.layer.borderColor = Colors.borderGray.cgColor
        textField.backgroundColor = UIColor(Colors.controlBackground)
        textField.keyboardType = .numberPad
        textField.placeholder = "1234 1234 1234 1234"
        textField.textContentType = .creditCardNumber
        textField.rightViewMode = .always
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
    
    func updateUIView(_ uiView: CardTypeUITextField, context: Context) {
        print("updateUIView: current text = \(uiView.text ?? "nil"), new text = \(text)")
        if uiView.text != text {
            uiView.text = text
        }
        
        if uiView.cardImageView.image != cardIcon {
            UIView.transition(with: uiView.cardImageView, duration: 0.35, options: [.transitionFlipFromTop], animations: {
                uiView.cardImageView.image = cardIcon
            }, completion: nil)
        }
        if isFocused {
            uiView.layer.borderColor = Color.dispatchBlue.cgColor
        } else if !isValid {
            uiView.layer.borderColor = Color.dispatchRed.cgColor
        } else {
            uiView.layer.borderColor = Colors.borderGray.cgColor
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

extension UITextField {
    func setRightView(_ view: UIView, padding: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = true
        let outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(view)
        
        outerView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: view.frame.size.width + padding,
                height: view.frame.size.height + padding
            )
        )
        
        view.center = CGPoint(
            x: outerView.bounds.size.width / 2,
            y: outerView.bounds.size.height / 2
        )
        
        rightView = outerView
        rightViewMode = .always
    }
}

#Preview {
    @State var creditCardNumber = ""
    return VStack {
        CreditCardTextField(text: $creditCardNumber, isValid: true)
            .frame(height: 44)
        CreditCardTextField(text: $creditCardNumber, isValid: false)
            .frame(height: 44)
//            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))

        Text("Entered Number: \(creditCardNumber)")
            .padding()
    }
    .padding()

}
