import SwiftUI

@available(iOS 15.0, *)
struct HTMLLabel: UIViewRepresentable {
    @Preference(\.theme) var theme
    let htmlString: String
    let bulletSpacing: CGFloat
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        let textColor: UIColor = theme.mode == .light ? .black : .white
        let attributedString = htmlString.htmlAttributedString(textColor: textColor)
        let modifiedAttributedString = attributedString.modifyBulletSpacing(spacing: bulletSpacing)
        uiView.attributedText = modifiedAttributedString
    }
}


@available(iOS 15.0, *)
struct HTMLTextView: UIViewRepresentable {
    @Preference(\.theme) var theme

    let htmlString: String
    let bulletSpacing: CGFloat
//    let width: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        let textColor: UIColor = theme.mode == .light ? .black : .white
        let attributedString = htmlString.htmlAttributedString(textColor: textColor)
        let modifiedAttributedString = attributedString.modifyBulletSpacing(spacing: bulletSpacing)
        uiView.attributedText = modifiedAttributedString

        // Resize the UITextView based on its content size
//        let contentSize = uiView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
//        uiView.frame.size = contentSize
//        uiView.invalidateIntrinsicContentSize()
        // Set the frame size explicitly
//        uiView.frame.size = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
//        uiView.sizeToFit()

    }
}

@available(iOS 15.0, *)
extension UIColor {
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let hexString = String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        return hexString
    }
}

@available(iOS 15.0, *)
fileprivate extension String {
    func htmlAttributedString(textColor: UIColor) -> NSAttributedString {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: -apple-system;
                font-size: 14px;
                color: \(textColor.hexString);
              }
              h1 { font-size: 28px; font-weight: bold; }
              h2 { font-size: 22px; font-weight: medium; }
              h3 { font-size: 20px; font-weight: medium; }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """
        
        guard let data = htmlTemplate.data(using: .utf16) else {
            return NSAttributedString()
        }
        
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) else {
            return NSAttributedString()
        }
        
        return attributedString
    }
}

@available(iOS 15.0, *)
fileprivate extension NSAttributedString {
    func modifyBulletSpacing(spacing: CGFloat, lineSpacing: CGFloat = 2) -> NSAttributedString {
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: spacing)]
        paragraphStyle.defaultTabInterval = spacing
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = spacing
        paragraphStyle.lineSpacing = lineSpacing

        mutableAttributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: length)
        )
        
        return mutableAttributedString
    }
}

@available(iOS 15.0, *)
#Preview {
    let html = """
    <h1>Heading</h1>
    <p>paragraph with enough text for us to test what the alignment does on multiple linebreaks</p>
    <ul>
        <li>paragraph</li>
        <li>paragraph</li>
        <li>paragraph</li>
    </ul>
    <h4>paragraph.</h4>
    """


    return HTMLTextView(
        htmlString: html,
        bulletSpacing: 5
//        width: 300
    )
    .padding()
}
