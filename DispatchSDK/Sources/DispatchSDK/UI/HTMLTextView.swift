import SwiftUI
import WebKit

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
fileprivate let html = """
<h1>Heading</h1>
<p>paragraph with enough text for us to test what the alignment does on multiple linebreaks</p>
<ul>
    <li>paragraph</li>
    <li>paragraph</li>
    <li>paragraph</li>
</ul>
<h4>paragraph.</h4>
"""

struct TestHTMLText: View {
    var body: some View {
        if let nsAttributedString = try? NSMutableAttributedString(
            data: Data(html.utf8),
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        ) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacingBefore = 1
            paragraphStyle.paragraphSpacing = 2
            

            nsAttributedString.enumerateAttribute(
                .paragraphStyle,
                in: NSRange(location: 0, length: nsAttributedString.length),
                options: []
            )     { (paragraphStyle, range, _) in
                guard let paragraphStyle = paragraphStyle as? NSParagraphStyle else { return }
                let updatedStyle = NSMutableParagraphStyle()
                updatedStyle.alignment = .right
                updatedStyle.setParagraphStyle(paragraphStyle)
                updatedStyle.paragraphSpacing = 5

                // Here we can modify paragraphs. Also could add condition to update only paragraphs with lists.
                updatedStyle.firstLineHeadIndent = 0
                updatedStyle.headIndent = 20
                
                nsAttributedString.addAttribute(.paragraphStyle, value: updatedStyle, range: range)
            }


            if let attributedString = try? AttributedString(
                nsAttributedString,
                including: \.uiKit
            ) {
                return Text(attributedString)
                    .foregroundStyle(.red)
            } else {
                return Text(html)
                    .foregroundStyle(.green)
            }
        } else {
            // fallback...
            return Text(html)
                .foregroundStyle(.blue)
        }
    }
}


struct TestHTMLTextPreviews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TestHTMLText()
            TestHTMLText()
//            HTMLStringView(htmlContent: html)
        }
    }
}
