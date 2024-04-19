import Foundation

public enum Style: String, Codable {
    case round = "ROUNDED"
    case sharp = "SHARP"
    case soft = "SOFT"
}


public enum Mode: String, Codable {
    case light = "LIGHT"
    case dark = "DARK"
}

public struct Theme: Codable, Equatable {
    public let buttonStyle: Style?
    public let successButtonText: String?
    public let applyThemeToCheckout: Bool?
    public let isDynamic: Bool?
    public let ctaStyle: Style
    public let inputStyle: Style
    public let mode: Mode
    
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
    public static func mock(
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

import SwiftUI
extension Theme {
    public var colorScheme: ColorScheme {
        return mode == .dark ? .dark : .light
    }
}

extension Theme {
    public static let soft = Theme.mock(ctaStyle: .soft, inputStyle: .soft)
    public static let sharp = Theme.mock(ctaStyle: .sharp, inputStyle: .sharp)
    public static let round = Theme.mock(ctaStyle: .round, inputStyle: .round)
    public static let `default` = Theme.init(buttonStyle: .round, successButtonText: nil, applyThemeToCheckout: nil, isDynamic: nil, ctaStyle: .round, inputStyle: .round, mode: .light)
}

// TODO: These are just for testing and can be refactored or removde
extension Theme {
    func toggle() -> Theme {
        return mode == .light ? darkMode() : lightMode()
    }
    func darkMode() -> Theme {
        return .init(
            buttonStyle: buttonStyle,
            successButtonText: successButtonText,
            applyThemeToCheckout: applyThemeToCheckout,
            isDynamic: isDynamic,
            ctaStyle: ctaStyle,
            inputStyle: inputStyle,
            mode: .dark
        )
    }
    
    func lightMode() -> Theme {
        return .init(
            buttonStyle: buttonStyle,
            successButtonText: successButtonText,
            applyThemeToCheckout: applyThemeToCheckout,
            isDynamic: isDynamic,
            ctaStyle: ctaStyle,
            inputStyle: inputStyle,
            mode: .light
        )
    }
}

public struct ThemeInput: Codable {
    public let applyThemeToCheckout: Bool?
    public let ctaStyle: Style?
    public let googleFont: String?
    public let inputStyle: Style?
    public let isDynamic: Bool?
    public let mode: Mode?
    public let primaryColor: String?
    
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
