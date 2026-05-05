// CommonComponents.swift — Reusable UI components

import SwiftUI

// MARK: - Color Token Resolver

extension ColorToken {
    var swiftUIColor: Color {
        switch self {
        case .blue:    return .appBlue
        case .green:   return .appGreen
        case .gold:    return .gold
        case .purple:  return .appPurple
        case .muted:   return .muted
        case .jobsBg:  return .jobsBg
        case .blueBg:  return .blueBg
        case .greenBg: return .greenBg
        case .goldBg:  return .goldBg
        case .purpleBg: return .purpleBg
        case .cream:   return .cream
        }
    }
}

// MARK: - Logo Mark
// Uses AppLogo image asset when available; falls back to the "I" mark.
// Drop your 1024×1024 logo PNG into Assets.xcassets/AppLogo.imageset/ and it
// will automatically appear everywhere the LogoMark component is used.

struct LogoMark: View {
    var size: CGFloat = 72

    var body: some View {
        Group {
            if UIImage(named: "AppLogo") != nil {
                Image("AppLogo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.31))
                    .accentButtonShadow()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.31)
                        .fill(Color.accent)
                        .frame(width: size, height: size)
                        .accentButtonShadow()
                    Text("I")
                        .font(.fraunces(size * 0.5, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Language Pill

struct LanguagePill: View {
    let language: Language
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(language.flag).font(.system(size: 15))
                Text(language.code)
                    .font(.jakarta(12, weight: .bold))
                    .foregroundColor(.ink)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.surface)
            .clipShape(Capsule())
            .pillShadow()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Section Label

struct SectionLabel: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.jakarta(12, weight: .bold))
            .foregroundColor(.muted)
            .kerning(1.0)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Primary Button

struct PrimaryButton: View {
    let label: String
    var isFullWidth: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.jakarta(16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.vertical, 16)
                .padding(.horizontal, isFullWidth ? 0 : 24)
                .background(Color.accent)
                .cornerRadius(Radius.button)
                .accentButtonShadow()
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Ghost Button

struct GhostButton: View {
    let label: String
    var icon: String? = nil
    var iconSystem: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if let icon { Text(icon).font(.system(size: 14)) }
                if let sys = iconSystem {
                    Image(systemName: sys).font(.system(size: 13, weight: .medium))
                }
                Text(label).font(.jakarta(14, weight: .semibold))
            }
            .foregroundColor(.ink)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(Color.surface)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.faint, lineWidth: 1))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Back Button

struct BackButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.ink)
                .frame(width: 36, height: 36)
                .background(Color.surface)
                .cornerRadius(Radius.badge)
                .cardShadow()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Scale Button Style

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Card Container

struct CardView<Content: View>: View {
    var padding: CGFloat = 16
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(padding)
            .background(Color.surface)
            .cornerRadius(Radius.card)
            .cardShadow()
    }
}

// MARK: - Typing Indicator

struct TypingIndicator: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(Color.muted)
                    .frame(width: 7, height: 7)
                    .offset(y: animate ? -4 : 0)
                    .animation(
                        .easeInOut(duration: 0.45)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.15),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
    }
}

// MARK: - Color Token Badge

struct CategoryBadge: View {
    let emoji: String
    let bgColor: Color
    var size: CGFloat = 48
    var radius: CGFloat = 14
    var emojiSize: CGFloat = 22

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .fill(bgColor)
                .frame(width: size, height: size)
            Text(emoji).font(.system(size: emojiSize))
        }
    }
}

// MARK: - Haptics

enum Haptics {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
