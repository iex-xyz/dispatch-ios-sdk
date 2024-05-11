import SwiftUI

@available(iOS 15.0, *)
struct ThemeKey: EnvironmentKey {
    static var defaultValue: Theme = .default
}

@available(iOS 15.0, *)
extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}


