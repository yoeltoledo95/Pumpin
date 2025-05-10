import SwiftUI

enum AppTheme {
    enum Colors {
        // Light Mode Colors
        static let light = AppColorScheme(
            primary: Color(hex: "1E2A38"),
            secondary: Color(hex: "475569"),
            background: Color(hex: "F8FAFC"),
            cardBackground: Color.white,
            accent: Color(hex: "F97316"),
            success: Color(hex: "22C55E"),
            border: Color(hex: "E2E8F0"),
            textPrimary: Color(hex: "1E2A38"),
            textSecondary: Color(hex: "64748B")
        )
        
        // Dark Mode Colors
        static let dark = AppColorScheme(
            primary: Color(hex: "E2E8F0"),
            secondary: Color(hex: "94A3B8"),
            background: Color(hex: "0F172A"),
            cardBackground: Color(hex: "1E293B"),
            accent: Color(hex: "FB923C"),
            success: Color(hex: "4ADE80"),
            border: Color(hex: "334155"),
            textPrimary: Color(hex: "F1F5F9"),
            textSecondary: Color(hex: "94A3B8")
        )
        
        static func current(_ colorScheme: SwiftUI.ColorScheme?) -> AppColorScheme {
            colorScheme == .dark ? dark : light
        }
    }
    
    enum Fonts {
        static let title = Font.system(size: 24, weight: .bold)
        static let headline = Font.system(size: 20, weight: .semibold)
        static let body = Font.system(size: 16)
        static let caption = Font.system(size: 14)
    }
    
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
    
    enum CornerRadius {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
    }
}

struct AppColorScheme {
    let primary: Color
    let secondary: Color
    let background: Color
    let cardBackground: Color
    let accent: Color
    let success: Color
    let border: Color
    let textPrimary: Color
    let textSecondary: Color
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 