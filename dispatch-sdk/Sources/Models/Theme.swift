import Foundation

enum Style: String, Codable {
    case round = "ROUNDED"
    case sharp = "SHARP"
    case soft = "SOFT"
}


enum Mode: String, Codable {
    case light = "LIGHT"
    case dark = "DARK"
}

struct Theme: Codable, Equatable {
    let buttonStyle: Style?
    let successButtonText: String?
    let applyThemeToCheckout: Bool?
    let isDynamic: Bool?
    let ctaStyle: Style
    let inputStyle: Style
    let mode: Mode
    
    enum CodingKeys: String, CodingKey {
        case buttonStyle
        case successButtonText
        case applyThemeToCheckout
        case isDynamic
        case ctaStyle
        case inputStyle
        case mode
    }
}

extension Theme {
    static func mock(
        buttonStyle: Style? = .round,
        successButtonText: String? = "Order Status",
        applyThemeToCheckout: Bool = false,
        isDynamic: Bool? = true,
        ctaStyle: Style = .soft,
        inputStyle: Style = .soft,
        mode: Mode = .light
    ) -> Self {
        Theme(
            buttonStyle: buttonStyle,
            successButtonText: successButtonText,
            applyThemeToCheckout: applyThemeToCheckout,
            isDynamic: isDynamic,
            ctaStyle: ctaStyle,
            inputStyle: inputStyle,
            mode: mode
        )
    }
}

extension Theme {
    static let soft = Theme.mock(ctaStyle: .soft, inputStyle: .soft)
    static let sharp = Theme.mock(ctaStyle: .sharp, inputStyle: .sharp)
    static let round = Theme.mock(ctaStyle: .round, inputStyle: .round)
    static let `default` = Theme.init(buttonStyle: .round, successButtonText: nil, applyThemeToCheckout: nil, isDynamic: nil, ctaStyle: .round, inputStyle: .round, mode: .light)
}

struct ThemeInput: Codable {
    let applyThemeToCheckout: Bool?
    let ctaStyle: Style?
    let googleFont: String?
    let inputStyle: Style?
    let isDynamic: Bool?
    let mode: Mode?
    let primaryColor: String?
    
    enum CodingKeys: String, CodingKey {
        case applyThemeToCheckout
        case ctaStyle
        case googleFont
        case inputStyle
        case isDynamic
        case mode
        case primaryColor
    }
}
