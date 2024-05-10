import UIKit

class PaddedTextField: UITextField {
    var theme: Theme?
    var textPadding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    
    init(theme: Theme? = nil) {
        self.theme = theme
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let theme else {
            return
        }
        
        switch theme.inputStyle {
        case .rounded, .round:
            layer.cornerRadius = bounds.height / 2
        default:
            layer.cornerRadius = theme.cornerRadius
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}


