import Foundation

enum Style: String, Codable {
    case round = "ROUND"
    case sharp = "SHARP"
    case soft = "SOFT"
}

enum Mode: String, Codable {
    case light = "LIGHT"
    case dark = "DARK"
}

struct Theme: Codable {
    let applyThemeToCheckout: Bool?
    let ctaStyle: Style
    let inputStyle: Style
    let isDynamic: Bool?
    let mode: Mode
    let primaryColor: String?
    
    init(
        applyThemeToCheckout: Bool = false,
        ctaStyle: Style = .round,
        inputStyle: Style = .round,
        isDynamic: Bool = false,
        mode: Mode = .dark,
        primaryColor: String = "#fff"
    ) {
        self.applyThemeToCheckout = applyThemeToCheckout
        self.ctaStyle = ctaStyle
        self.inputStyle = inputStyle
        self.isDynamic = isDynamic
        self.mode = mode
        self.primaryColor = primaryColor
    }

    enum CodingKeys: String, CodingKey {
        case applyThemeToCheckout
        case ctaStyle
        case inputStyle
        case isDynamic
        case mode
        case primaryColor
    }
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
