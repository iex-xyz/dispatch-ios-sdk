import SwiftUI
struct ItemsPerPageKey: EnvironmentKey {
    static var defaultValue: Int = 10
}

extension EnvironmentValues {
    var itemsPerPage: Int {
        get { self[ItemsPerPageKey.self] }
        set { self[ItemsPerPageKey.self] = newValue }
    }
}
struct ExpandableText: View {
    internal var text : String
    
    internal var markdownText: AttributedString {
        (try? AttributedString(markdown: text, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))) ?? AttributedString()
    }
    
    @Preference(\.theme) var theme

    internal var font: Font = .body
    internal var lineLimit: Int = 3
    internal var foregroundColor: Color = .primary
    
    internal var expandButton: TextSet
    internal var collapseButton: TextSet? = nil
    
    internal var animation: Animation? = .none
    internal var expandHandler: (() -> Void)?

    @State private var expand : Bool = false
    @State private var truncated : Bool = false
    @State private var fullSize: CGFloat = 0
    
    
    init(
        text: String,
        font: Font = .body,
        lineLimit: Int = 3,
        expandButtonCta: String = "more",
        collapseButtonCta: String? = "less",//TextSet(text: "less", font: .body, color: .blue),
        animation: Animation? = nil,
        expandHandler:(() -> Void)? = nil
    ) {
        self.text = text
        self.font = font
        self.lineLimit = lineLimit
        self.foregroundColor = .primary
        self.expandButton = TextSet(
            text: expandButtonCta,
            font: font.bold(),
            color: foregroundColor
        )
        if let collapseButtonCta {
            self.collapseButton = TextSet(
                text: collapseButtonCta,
                font: font.bold(),
                color: foregroundColor
            )
        }
        self.animation = animation
        self.expand = expand
        self.truncated = truncated
        self.fullSize = fullSize
        self.expandHandler = expandHandler
    }

    internal var body: some View {
        ZStack(alignment: .bottomTrailing){
            Group {
                if #available(iOS 15.0, *) {
                    Text(markdownText)
                } else {
                    Text(text)
                }
            }
                .font(font)
                .foregroundColor(foregroundColor)
                .lineLimit(expand == true ? nil : lineLimit)
                .animation(animation, value: expand)
                .mask(
                    VStack(spacing: 0){
                        Rectangle()
                            .foregroundColor(.black)
                        
                        HStack(spacing: 0){
                            Rectangle()
                                .foregroundColor(.black)
                            if truncated{
                                if !expand {
                                    HStack(alignment: .bottom,spacing: 0){
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                Gradient.Stop(color: .black, location: 0),
                                                Gradient.Stop(color: .clear, location: 0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing)
                                            .frame(width: 32, height: expandButton.text.heightOfString(usingFont: fontToUIFont(font: expandButton.font)))
                                        
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: expandButton.text.widthOfString(usingFont: fontToUIFont(font: expandButton.font)), alignment: .center)
                                    }
                                }
                                else if let collapseButton = collapseButton {
                                    HStack(alignment: .bottom,spacing: 0){
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                Gradient.Stop(color: .black, location: 0),
                                                Gradient.Stop(color: .clear, location: 0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing)
                                            .frame(width: 32, height: collapseButton.text.heightOfString(usingFont: fontToUIFont(font: collapseButton.font)))
                                        
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: collapseButton.text.widthOfString(usingFont: fontToUIFont(font: collapseButton.font)), alignment: .center)
                                    }
                                }
                            }
                        }
                        .frame(height: expandButton.text.heightOfString(usingFont: fontToUIFont(font: font)))
                    }
                )
            
            if truncated {
                if let collapseButton = collapseButton {
                    Button(action: {
                        if let expandHandler {
                            expandHandler()
                        } else {
                            self.expand.toggle()
                        }
                    }, label: {
                        Text(expand == false ? expandButton.text : collapseButton.text)
                            .font(expand == false ? expandButton.font : collapseButton.font)
                            .foregroundColor(expand == false ? expandButton.color : collapseButton.color)
                    })
                }
                else if !expand {
                    Button(action: {
                        self.expand = true
                    }, label: {
                        Text(expandButton.text)
                            .font(expandButton.font)
                            .foregroundColor(expandButton.color)
                    })
                }
            }
        }
        .background(
            ZStack{
                if !truncated {
                    if fullSize != 0 {
                        Text(text)
                            .font(font)
                            .lineLimit(lineLimit)
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .onAppear {
                                            if fullSize > geo.size.height {
                                                self.truncated = true
                                            }
                                        }
                                }
                            )
                    }
                    
                    Text(text)
                        .font(font)
                        .lineLimit(999)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(GeometryReader { geo in
                            Color.clear
                                .onAppear() {
                                    self.fullSize = geo.size.height
                                }
                        })
                }
            }
                .hidden()
        )
    }
}


#Preview {
    VStack(spacing: 32) {
        ExpandableText(
            text: "On the trail, details matter. Fast, rugged and ready for whatever wild comes your way and then we repeat with On the trail, details matter. Fast, rugged and ready for whatever wild comes your"
        )
        .lineLimit(2)
        ExpandableText(
            text: "On the trail, details matter. Fast, rugged and ready for whatever wild comes your way and then we repeat with On the trail, details matter. Fast, rugged and ready for whatever wild comes your"
        )
        .lineLimit(2)
        .environment(\.theme, .mock(mode: .dark))
    }
    .padding()
    .background(Color.dispatchLightGray)
}


extension ExpandableText {
    internal func font(_ font: Font) -> ExpandableText {
        var result = self
        
        result.font = font
        
        return result
    }
    internal func lineLimit(_ lineLimit: Int) -> ExpandableText {
        var result = self
        
        result.lineLimit = lineLimit
        return result
    }
    
    internal func foregroundColor(_ color: Color) -> ExpandableText {
        var result = self
        
        result.foregroundColor = color
        return result
    }
    
    internal func expandButton(_ expandButton: TextSet) -> ExpandableText {
        var result = self
        
        result.expandButton = expandButton
        return result
    }
    
    internal func collapseButton(_ collapseButton: TextSet) -> ExpandableText {
        var result = self
        
        result.collapseButton = collapseButton
        return result
    }
    
    internal func expandAnimation(_ animation: Animation?) -> ExpandableText {
        var result = self
        
        result.animation = animation
        return result
    }
}

extension String {
    fileprivate func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    fileprivate func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

internal struct TextSet {
    var text: String
    var font: Font
    var color: Color

    internal init(text: String, font: Font, color: Color) {
        self.text = text
        self.font = font
        self.color = color
    }
}

fileprivate func fontToUIFont(font: Font) -> UIFont {
    switch font {
    case .largeTitle:
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    case .title:
        return UIFont.preferredFont(forTextStyle: .title1)
    case .title2:
        return UIFont.preferredFont(forTextStyle: .title2)
    case .title3:
        return UIFont.preferredFont(forTextStyle: .title3)
    case .headline:
        return UIFont.preferredFont(forTextStyle: .headline)
    case .subheadline:
        return UIFont.preferredFont(forTextStyle: .subheadline)
    case .callout:
        return UIFont.preferredFont(forTextStyle: .callout)
    case .caption:
        return UIFont.preferredFont(forTextStyle: .caption1)
    case .caption2:
        return UIFont.preferredFont(forTextStyle: .caption2)
    case .footnote:
        return UIFont.preferredFont(forTextStyle: .footnote)
    case .body:
        return UIFont.preferredFont(forTextStyle: .body)
    default:
        return UIFont.preferredFont(forTextStyle: .body)
    }
}
