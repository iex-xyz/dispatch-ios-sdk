import SwiftUI
import WebKit

struct SVGTestView: View {
    let svg = """
      <svg width="23" height="8" viewBox="0 0 23 8" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path fill-rule="evenodd" clip-rule="evenodd" d="M23 0L6.17976 7.11224C4.77935 7.70451 3.60126 8 2.6519 8C1.5837 8 0.805557 7.62426 0.32768 6.87406C-0.292027 5.90607 -0.0211445 4.34963 1.04194 2.70658C1.67315 1.74622 2.47557 0.864831 3.25755 0.0216529C3.07356 0.319695 1.44954 3.01353 3.22561 4.28212C3.57699 4.53686 4.07659 4.66168 4.69118 4.66168C5.18439 4.66168 5.75043 4.58144 6.37269 4.41968L23 0Z" fill="white"/>
      </svg>
"""
    
    let svg2 = """
            <svg width="120" height="120" version="1.1" xmlns="http://www.w3.org/2000/svg">
              <defs>
                  <linearGradient id="Gradient1">
                    <stop offset="0%"   stop-color="red"/>
                    <stop offset="50%"  stop-color="black" stop-opacity="0"/>
                    <stop offset="100%" stop-color="blue"/>
                  </linearGradient>
              </defs>
              <rect x="10" y="10" rx="15" ry="15" width="100" height="100"
                    fill="url(#Gradient1)" />
            </svg>
      """
      
    
    let svgURL = "https://raw.githubusercontent.com/stephensilber/stephensilber.github.io/master/svg/nike.svg"
    
    var body: some View {
        VStack {
            SVGWebView(svg: svg2)
            SVGWebView2(url: URL(string: svgURL)!)
        }
        .frame(width: 100, height: 200)
        .padding()
        .background(.gray)
    }
}

public struct SVGWebView2: View {
    
    private let url: URL
    @State private var svg: String = ""
    
    public init(url: URL) {
        self.url = url
    }
    
    public var body: some View {
        WebView(html: "<div style=\"width: 100%; height: 100%;\">\(rewriteSVGSize(svg))</div>")
            .onAppear {
                downloadSVG()
            }
    }
    
    private func downloadSVG() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading SVG: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let svgString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.svg = svgString
                }
            }
        }.resume()
    }
    
    /// A hacky way to patch the size in the SVG root tag.
    private func rewriteSVGSize(_ string: String) -> String {
        guard let startRange = string.range(of: "<svg") else { return string }
        let remainder = startRange.upperBound..<string.endIndex
        guard let endRange = string.range(of: ">", range: remainder) else {
            return string
        }
        
        let tagRange = startRange.lowerBound..<endRange.upperBound
        let oldTag   = string[tagRange]
        
        var attrs : [ String : String ] = {
            final class Handler: NSObject, XMLParserDelegate {
                var attrs : [ String : String ]?
                
                func parser(_ parser: XMLParser, didStartElement: String,
                            namespaceURI: String?, qualifiedName: String?,
                            attributes: [ String : String ])
                {
                    self.attrs = attributes
                }
            }
            let parser  = XMLParser(data: Data((string[tagRange] + "</svg>").utf8))
            let handler = Handler()
            parser.delegate = handler
            
            guard parser.parse() else { return [:] }
            return handler.attrs ?? [:]
        }()
        
        if attrs["viewBox"] == nil &&
            (attrs["width"] != nil || attrs["height"] != nil)
        { // convert to viewBox
            let w = attrs.removeValue(forKey: "width")  ?? "100%"
            let h = attrs.removeValue(forKey: "height") ?? "100%"
            let x = attrs.removeValue(forKey: "x")      ?? "0"
            let y = attrs.removeValue(forKey: "y")      ?? "0"
            attrs["viewBox"] = "\(x) \(y) \(w) \(h)"
        }
        attrs.removeValue(forKey: "x")
        attrs.removeValue(forKey: "y")
        attrs["width"]  = "100%"
        attrs["height"] = "100%"
        
        func renderTag(_ tag: String, attributes: [ String : String ]) -> String {
            var ms = "<\(tag)"
            for ( key, value ) in attributes {
                ms += " \(key)=\""
                ms += value
                    .replacingOccurrences(of: "&",  with: "&amp;")
                    .replacingOccurrences(of: "<",  with: "&lt;")
                    .replacingOccurrences(of: ">",  with: "&gt;")
                    .replacingOccurrences(of: "'",  with: "&apos;")
                    .replacingOccurrences(of: "\"", with: "&quot;")
                ms += "\""
            }
            ms += ">"
            return ms
        }
        
        let newTag = renderTag("svg", attributes: attrs)
        return newTag == oldTag
        ? string
        : string.replacingCharacters(in: tagRange, with: newTag)
    }
    
    private struct WebView : UIViewRepresentable {
        
        let html : String
        
        private func makeWebView() -> WKWebView {
            let prefs = WKPreferences()
            prefs.javaScriptCanOpenWindowsAutomatically = false
            
            let config = WKWebViewConfiguration()
            config.preferences = prefs
            config.allowsAirPlayForMediaPlayback = false
            
            let webView = WKWebView(frame: .zero, configuration: config)
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.isScrollEnabled = false
            
            webView.loadHTMLString(html, baseURL: nil)
            
            // Sometimes necessary to make things show up initially. No idea why.
            DispatchQueue.main.async {
                let old = webView.frame
                webView.frame = .zero
                webView.frame = old
            }
            
            return webView
        }
        private func updateWebView(_ webView: WKWebView, context: Context) {
            webView.loadHTMLString(html, baseURL: nil)
            // Sometimes necessary to make things show up initially. No idea why.
            DispatchQueue.main.async {
                let old = webView.frame
                webView.frame = .zero
                webView.frame = old
            }

        }
        
        func makeUIView(context: Context) -> WKWebView {
            return makeWebView()
        }
        func updateUIView(_ webView: WKWebView, context: Context) {
            updateWebView(webView, context: context)
        }
    }
}


// Created by Helge Heß on 06.04.21.
// Also available as a package: https://github.com/ZeeZide/SVGWebView

import SwiftUI
import WebKit

/**
 * Display an SVG using a `WKWebView`.
 *
 * Used by [SVG Shaper for SwiftUI](https://zeezide.de/en/products/svgshaper/)
 * to display the SVG preview in the sidebar.
 *
 * This patches the XML of the SVG to fit the WebView contents.
 *
 * IMPORTANT: On macOS `WKWebView` requires the "outgoing internet connection"
 *            entitlement to operate, otherwise it'll show up blank.
 * Xcode Previews do not work quite right with the iOS variant, best to test in
 * a real simulator.
 */
public struct SVGWebView: View {
  
  private let svg: String
  
  public init(svg: String) { self.svg = svg }
  
  public var body: some View {
    WebView(html:
      "<div style=\"width: 100%; height: 100%;\">\(rewriteSVGSize(svg))</div>"
    )
  }
  
  /// A hacky way to patch the size in the SVG root tag.
  private func rewriteSVGSize(_ string: String) -> String {
    guard let startRange = string.range(of: "<svg") else { return string }
    let remainder = startRange.upperBound..<string.endIndex
    guard let endRange = string.range(of: ">", range: remainder) else {
      return string
    }
    
    let tagRange = startRange.lowerBound..<endRange.upperBound
    let oldTag   = string[tagRange]
    
    var attrs : [ String : String ] = {
      final class Handler: NSObject, XMLParserDelegate {
        var attrs : [ String : String ]?
        
        func parser(_ parser: XMLParser, didStartElement: String,
                    namespaceURI: String?, qualifiedName: String?,
                    attributes: [ String : String ])
        {
          self.attrs = attributes
        }
      }
      let parser  = XMLParser(data: Data((string[tagRange] + "</svg>").utf8))
      let handler = Handler()
      parser.delegate = handler
        
      guard parser.parse() else { return [:] }
      return handler.attrs ?? [:]
    }()
    
    if attrs["viewBox"] == nil &&
      (attrs["width"] != nil || attrs["height"] != nil)
    { // convert to viewBox
      let w = attrs.removeValue(forKey: "width")  ?? "100%"
      let h = attrs.removeValue(forKey: "height") ?? "100%"
      let x = attrs.removeValue(forKey: "x")      ?? "0"
      let y = attrs.removeValue(forKey: "y")      ?? "0"
      attrs["viewBox"] = "\(x) \(y) \(w) \(h)"
    }
    attrs.removeValue(forKey: "x")
    attrs.removeValue(forKey: "y")
    attrs["width"]  = "100%"
    attrs["height"] = "100%"
    
    func renderTag(_ tag: String, attributes: [ String : String ]) -> String {
      var ms = "<\(tag)"
      for ( key, value ) in attributes {
        ms += " \(key)=\""
        ms += value
          .replacingOccurrences(of: "&",  with: "&amp;")
          .replacingOccurrences(of: "<",  with: "&lt;")
          .replacingOccurrences(of: ">",  with: "&gt;")
          .replacingOccurrences(of: "'",  with: "&apos;")
          .replacingOccurrences(of: "\"", with: "&quot;")
        ms += "\""
      }
      ms += ">"
      return ms
    }
    
    let newTag = renderTag("svg", attributes: attrs)
    return newTag == oldTag
         ? string
         : string.replacingCharacters(in: tagRange, with: newTag)
  }

  #if os(macOS)
    typealias UXViewRepresentable = NSViewRepresentable
  #else
    typealias UXViewRepresentable = UIViewRepresentable
  #endif
  
  private struct WebView : UXViewRepresentable {
    
    let html : String
    
    private func makeWebView() -> WKWebView {
      let prefs = WKPreferences()
      #if os(macOS)
        if #available(macOS 10.5, *) {} else { prefs.javaEnabled = false }
      #endif
      if #available(macOS 11, *) {} else { prefs.javaScriptEnabled = false }
      prefs.javaScriptCanOpenWindowsAutomatically = false
      
      let config = WKWebViewConfiguration()
      config.preferences = prefs
      config.allowsAirPlayForMediaPlayback = false
      
      if #available(macOS 10.5, *) {
        let pagePrefs : WKWebpagePreferences = {
          let prefs = WKWebpagePreferences()
          prefs.preferredContentMode = .desktop
          if #available(macOS 11, *) {
            prefs.allowsContentJavaScript = false
          }
          return prefs
        }()
        config.defaultWebpagePreferences = pagePrefs
      }
      
      let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
      #if !os(macOS)
        webView.scrollView.isScrollEnabled = false
      #endif
      
      webView.loadHTMLString(html, baseURL: nil)
      
      // Sometimes necessary to make things show up initially. No idea why.
      DispatchQueue.main.async {
        let old = webView.frame
        webView.frame = .zero
        webView.frame = old
      }
      
      return webView
    }
    private func updateWebView(_ webView: WKWebView, context: Context) {
      webView.loadHTMLString(html, baseURL: nil)
    }

    #if os(macOS)
      func makeNSView(context: Context) -> WKWebView {
        return makeWebView()
      }
      func updateNSView(_ webView: WKWebView, context: Context) {
        updateWebView(webView, context: context)
      }
    #else // iOS etc
      func makeUIView(context: Context) -> WKWebView {
        return makeWebView()
      }
      func updateUIView(_ webView: WKWebView, context: Context) {
        updateWebView(webView, context: context)
      }
    #endif
  }
}

struct SVGWebView_Previews : PreviewProvider {

  static var previews: some View {
    SVGWebView(svg:
      """
      <svg viewBox="0 0 100 100">
        <rect x="10" y="10" width="80" height="80"
              fill="gold" stroke="blue" stroke-width="4" />
      </svg>
      """
    )
    .frame(width: 300, height: 200)

    SVGWebView(svg:
      """
      <svg width="120" height="120" version="1.1" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <linearGradient id="Gradient1">
              <stop offset="0%"   stop-color="red"/>
              <stop offset="50%"  stop-color="black" stop-opacity="0"/>
              <stop offset="100%" stop-color="blue"/>
            </linearGradient>
        </defs>
        <rect x="10" y="10" rx="15" ry="15" width="100" height="100"
              fill="url(#Gradient1)" />
      </svg>
      """)
      .frame(width: 200, height: 200)
  }
}
