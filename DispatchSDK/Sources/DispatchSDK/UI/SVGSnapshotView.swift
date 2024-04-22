import SwiftUI
import WebKit

import UIKit

extension CGSize {
    /// Function to resize this size so that the height matches the specified height while maintaining the aspect ratio.
    ///
    /// - Parameter targetHeight: The target height to resize to.
    /// - Returns: A new `CGSize` with the updated dimensions.
    func resized(toHeight targetHeight: CGFloat) -> CGSize {
        let scaleFactor = targetHeight / self.height
        let newWidth = self.width * scaleFactor
        return CGSize(width: newWidth, height: targetHeight)
    }
}

struct SVGSnapshotView: UIViewRepresentable {
    let url: String
    var onSnapshotTaken: (UIImage?, CGSize) -> Void

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
//        webView.isHidden = true
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        // Download SVG data
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if let data = data, let svgString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    webView.loadHTMLString(svgString, baseURL: nil)
                }
            }
        }.resume()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SVGSnapshotView

        init(_ parent: SVGSnapshotView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            let js = "var svg = document.querySelector('svg'); var width = svg.getAttribute('width'); var height = svg.getAttribute('height'); width + ',' + height;"
            webView.evaluateJavaScript(js) { result, error in
                guard 
                    let dimensionString = result as? String,
                    error == nil
                else {
                    DispatchQueue.main.async {
                        self.parent.onSnapshotTaken(nil, .zero)
                    }
                    return
                }

                
                let dimensions = dimensionString.split(separator: ",").map { Double($0) ?? 0 }
                if dimensions.count == 2 {
                    let size = CGSize(width: dimensions[0], height: dimensions[1])
                    print("[SVGSnapshotView]: Snapshotting SVG with size \(dimensions)", size.resized(toHeight: 24))

                    let config = WKSnapshotConfiguration()
                    webView.takeSnapshot(with: config) { image, error in
                        DispatchQueue.main.async {
                            self.parent.onSnapshotTaken(image, size)
                        }
                    }
                }
            }
        }
    }
}

struct AsyncSVGView: View {
    let url: URL
    
    @State private var snapshotImage: UIImage?
    @State private var snapshotSize: CGSize = .zero

    init(url: URL) {
        self.url = url
    }

    var body: some View {
        ZStack {
            if let image = snapshotImage {
                HStack {
                    Spacer()
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: snapshotSize.width, height: snapshotSize.height)
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                }
            } else {
                SVGSnapshotView(url: url.absoluteString) { image, size in
                    self.snapshotSize = size.resized(toHeight: 24)
                    self.snapshotImage = image
                }
            }
        }
        .frame(maxWidth: 60)
        .frame(height: 24)
    }
}
