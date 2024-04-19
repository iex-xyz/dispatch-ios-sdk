import SwiftUI


public struct ThemeKey: EnvironmentKey {
    public static var defaultValue: Theme = .default
}
extension EnvironmentValues {
    public var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}


