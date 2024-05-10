import SwiftUI

struct ThemeKey: EnvironmentKey {
    static var defaultValue: Theme = .default
}
extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}


