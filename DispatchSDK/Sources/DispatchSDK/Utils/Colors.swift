import SwiftUI

extension Color {
    static var dispatchRed: Color = Color(hex: "#FF4343")
    static var dispatchBlue: Color = Color(hex: "#158AFF")
    static var dispatchGreen: Color = Color(hex: "#65DF81")
    static var dispatchOrange: Color = Color(hex: "#FE6A3B")

    static var dispatchBlueDarkened: Color = Color(hex: "#2750AE")
    static var dispatchLightGray: Color = Color(hex: "#686C74")
    static var dispatchDarkGray: Color = Color(hex: "#0D1116")
    static var dispatchDarkBackground: Color = Color(hex: "#0D1116")
    static var dispatchLightBackground: Color = Color(hex: "#FAFAFA")

    static var placeholderText: Color = Color.black.opacity(0.24)

    static var borderGrayDark: Color = Color(hex: "#2D2F33")
    static var borderGrayLight: Color = Color(hex: "#E8E8E8")

    static var shopPayPurple: Color = Color(hex: "#5A31F4")
}

struct Colors {
    @Preference(\.theme) static var theme
    static var borderGray: Color {
        switch theme.mode {
        case .dark:
            return .borderGrayDark
        case .light:
            return .borderGrayLight
        }
    }
    
    static var controlBackground: Color {
        switch theme.mode {
        case .dark:
            return .dispatchDarkBackground
        case .light:
            return .dispatchLightBackground
        }
    }
    
    static var placeholderColor: Color {
        switch theme.mode {
        case .dark:
            return .white.opacity(0.24)
        case .light:
            return .black.opacity(0.24)
        }
    }

}
