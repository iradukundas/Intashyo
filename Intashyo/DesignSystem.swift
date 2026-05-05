// DesignSystem.swift — All design tokens from tokens.md

import SwiftUI

// MARK: - Colors

extension Color {
    static let accent      = Color(hex: "#bf4b2e")
    static let bg          = Color(hex: "#fdf8f3")
    static let surface     = Color.white
    static let cream       = Color(hex: "#f5ece0")
    static let ink         = Color(hex: "#1c1209")
    static let muted       = Color(hex: "#7a6a5a")
    static let faint       = Color(hex: "#e8ddd0")
    static let appGreen    = Color(hex: "#2a7a50")
    static let greenBg     = Color(hex: "#e4f4ed")
    static let appBlue     = Color(hex: "#1a5fa8")
    static let blueBg      = Color(hex: "#ddeaf8")
    static let appPurple   = Color(hex: "#6b38a0")
    static let purpleBg    = Color(hex: "#f0e8fa")
    static let gold        = Color(hex: "#a07020")
    static let goldBg      = Color(hex: "#fdf3d8")
    static let appRed      = Color(hex: "#c0392b")
    static let redBg       = Color(hex: "#fce8e6")
    static let jobsBg      = Color(hex: "#e8eeff")

    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}

// MARK: - Typography

extension Font {
    // Fraunces — Display / Headings
    static func fraunces(_ size: CGFloat, weight: Font.Weight = .bold, italic: Bool = false) -> Font {
        let suffix = italic ? "Italic" : ""
        let weightName: String
        switch weight {
        case .bold:   weightName = "Bold"
        case .light:  weightName = "Light"
        case .semibold: weightName = "SemiBold"
        default:      weightName = "Regular"
        }
        let name = "Fraunces-\(weightName)\(suffix)"
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        }
        // Fallback: system serif
        return .system(size: size, weight: weight, design: .serif).italic()
    }

    // Plus Jakarta Sans — Body / UI
    static func jakarta(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let name: String
        switch weight {
        case .bold:     name = "PlusJakartaSans-Bold"
        case .semibold: name = "PlusJakartaSans-SemiBold"
        case .medium:   name = "PlusJakartaSans-Medium"
        case .heavy:    name = "PlusJakartaSans-ExtraBold"
        default:        name = "PlusJakartaSans-Regular"
        }
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        }
        return .system(size: size, weight: weight, design: .default)
    }
}

// MARK: - Spacing

enum Spacing {
    static let xs:  CGFloat = 4
    static let sm:  CGFloat = 8
    static let md:  CGFloat = 12
    static let lg:  CGFloat = 16
    static let xl:  CGFloat = 20
    static let xl2: CGFloat = 24
    static let xl3: CGFloat = 32
}

// MARK: - Radius

enum Radius {
    static let card:     CGFloat = 18
    static let category: CGFloat = 16
    static let button:   CGFloat = 14
    static let input:    CGFloat = 14
    static let pill:     CGFloat = 22
    static let badge:    CGFloat = 10
    static let sheet:    CGFloat = 24
    static let logo:     CGFloat = 22
}

// MARK: - Shadows

extension View {
    func cardShadow() -> some View {
        self.shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
    }

    func pillShadow() -> some View {
        self.shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }

    func accentButtonShadow() -> some View {
        self.shadow(color: Color.accent.opacity(0.33), radius: 12, x: 0, y: 8)
    }

    func emergencyBlockShadow() -> some View {
        self.shadow(color: Color.appRed.opacity(0.27), radius: 12, x: 0, y: 8)
    }
}
