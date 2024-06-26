import Foundation

enum Style: String, Codable {
    case round = "ROUND"
    case rounded = "ROUNDED"
    case sharp = "SHARP"
    case soft = "SOFT"
}


enum Mode: String, Codable {
    case light = "LIGHT"
    case dark = "DARK"
}

@available(iOS 15.0, *)
struct Theme: Codable, Equatable {
    let buttonStyle: Style?
    let successButtonText: String?
    let applyThemeToCheckout: Bool?
    let isDynamic: Bool?
    let ctaStyle: Style
    let inputStyle: Style
    let mode: Mode
    private let _primaryColor: String
    var primaryColor: Color {
        Color(hex: _primaryColor)
    }
    
    init(
        buttonStyle: Style?,
        successButtonText: String?,
        applyThemeToCheckout: Bool?,
        isDynamic: Bool?,
        ctaStyle: Style,
        inputStyle: Style,
        mode: Mode,
        primaryColor: String
    ) {
        self.buttonStyle = buttonStyle
        self.successButtonText = successButtonText
        self.applyThemeToCheckout = applyThemeToCheckout
        self.isDynamic = isDynamic
        self.ctaStyle = ctaStyle
        self.inputStyle = inputStyle
        self.mode = mode
        self._primaryColor = primaryColor
    }
    
    // Write custom decoer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        buttonStyle = try container.decodeIfPresent(Style.self, forKey: .buttonStyle)
        successButtonText = try container.decodeIfPresent(String.self, forKey: .successButtonText)
        applyThemeToCheckout = try container.decodeIfPresent(Bool.self, forKey: .applyThemeToCheckout)
        isDynamic = try container.decodeIfPresent(Bool.self, forKey: .isDynamic)
        ctaStyle = try container.decode(Style.self, forKey: .ctaStyle)
        inputStyle = try container.decode(Style.self, forKey: .inputStyle)
        mode = try container.decodeIfPresent(Mode.self, forKey: .mode) ?? .light
        _primaryColor = try container.decodeIfPresent(String.self, forKey: ._primaryColor) ?? "#158AFF"
    }

    enum CodingKeys: String, CodingKey {
        case buttonStyle
        case successButtonText
        case applyThemeToCheckout
        case isDynamic
        case ctaStyle
        case inputStyle
        case mode
        case _primaryColor = "primaryColor"
    }
}

@available(iOS 15.0, *)
extension Theme {
    static func mock(
        buttonStyle: Style? = .round,
        successButtonText: String? = "Order Status",
        applyThemeToCheckout: Bool = false,
        isDynamic: Bool? = true,
        ctaStyle: Style = .soft,
        inputStyle: Style = .soft,
        mode: Mode = .light,
        primaryColor: String = "#000000"
    ) -> Self {
        Theme(
            buttonStyle: buttonStyle,
            successButtonText: successButtonText,
            applyThemeToCheckout: applyThemeToCheckout,
            isDynamic: isDynamic,
            ctaStyle: ctaStyle,
            inputStyle: inputStyle,
            mode: mode,
            primaryColor: primaryColor
        )
    }
}

import SwiftUI

@available(iOS 15.0, *)
extension Theme {
    var colorScheme: ColorScheme {
        return mode == .dark ? .dark : .light
    }
    
    var backgroundColor: Color {
        return mode == .dark ? .black : .white
    }
    
    var cornerRadius: CGFloat {
        switch ctaStyle {
        case .round, .rounded:
            return 30
        case .soft:
            return 10
        case .sharp:
            return 0
        }

    }
}

@available(iOS 15.0, *)
extension Theme {
    static let soft = Theme.mock(ctaStyle: .soft, inputStyle: .soft)
    static let sharp = Theme.mock(ctaStyle: .sharp, inputStyle: .sharp)
    static let round = Theme.mock(ctaStyle: .round, inputStyle: .round)
    static let `default` = Theme.init(
        buttonStyle: .round,
        successButtonText: nil,
        applyThemeToCheckout: nil,
        isDynamic: nil,
        ctaStyle: .round,
        inputStyle: .round,
        mode: .light,
        primaryColor: "#158AFF"
    )
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

// NOTE: These are just for testing and can be removed]
@available(iOS 15.0, *)
extension Theme {
    func toggle() -> Theme {
        return mode == .light ? darkMode() : lightMode()
    }
    
    func cycleStyle() -> Theme {
        let newStyle: Style = self.inputStyle == .sharp ? .soft : self.inputStyle == .soft ? .round : .sharp
        return .init(
            buttonStyle: newStyle,
            successButtonText: successButtonText,
            applyThemeToCheckout: applyThemeToCheckout,
            isDynamic: isDynamic,
            ctaStyle: newStyle,
            inputStyle: newStyle,
            mode: mode,
            primaryColor: _primaryColor
        )
    }

    func darkMode() -> Theme {
        return .init(
            buttonStyle: buttonStyle,
            successButtonText: successButtonText,
            applyThemeToCheckout: applyThemeToCheckout,
            isDynamic: isDynamic,
            ctaStyle: ctaStyle,
            inputStyle: inputStyle,
            mode: .dark,
            primaryColor: "#ffffff"
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
            mode: .light,
            primaryColor: "#000000"
        )
    }
}
