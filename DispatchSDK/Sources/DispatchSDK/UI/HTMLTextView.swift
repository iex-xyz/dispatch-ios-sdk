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
<p style='{color: red;}'>paragraph.</p>
<ul>
<li>paragraph</li>
<li>paragraph</li>
<li>paragraph</li>
</ul>
"""

struct TestHTMLText: View {
    var body: some View {
        
        if let nsAttributedString = try? NSAttributedString(data: Data(html.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil),
           let attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) {
            Text(attributedString)
        } else {
            // fallback...
            Text(html)
        }
    }
}


struct TestHTMLTextPreviews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TestHTMLText()
            HTMLStringView(htmlContent: html)
        }
    }
}
