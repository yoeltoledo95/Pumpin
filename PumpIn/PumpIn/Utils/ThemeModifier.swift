import SwiftUI

struct ThemeModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .environment(\.theme, AppTheme.Colors.current(colorScheme))
    }
}

extension View {
    func withTheme() -> some View {
        modifier(ThemeModifier())
    }
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppColorScheme = AppTheme.Colors.light
}

extension EnvironmentValues {
    var theme: AppColorScheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
} 