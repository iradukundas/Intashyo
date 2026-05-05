// LanguageModalView.swift — Screen 04 (bottom sheet)

import SwiftUI

struct LanguageModalView: View {
    @Environment(AppState.self) private var appState
    @Binding var isPresented: Bool

    private var L: L { appState.L }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Backdrop
            Color.ink.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            // Sheet
            VStack(spacing: 0) {
                // Drag handle
                Capsule()
                    .fill(Color.faint)
                    .frame(width: 40, height: 4)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                // Title
                Text(L.changeLang)
                    .font(.fraunces(22, weight: .bold))
                    .foregroundColor(.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Hitamo · Choisir · Chagua · Choose")
                    .font(.jakarta(13))
                    .foregroundColor(.muted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                    .padding(.bottom, 20)

                // Language rows
                VStack(spacing: 12) {
                    ForEach(Language.allCases) { lang in
                        ModalLanguageRow(
                            language: lang,
                            isSelected: appState.selectedLanguage == lang
                        ) {
                            appState.switchLanguage(lang)
                            dismiss()
                        }
                    }
                }
                .padding(.bottom, 36)
            }
            .padding(.horizontal, Spacing.xl)
            .background(Color.bg)
            .cornerRadius(Radius.sheet, corners: [.topLeft, .topRight])
        }
        .ignoresSafeArea()
    }

    private func dismiss() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = false
        }
    }
}

// MARK: - Modal Language Row

struct ModalLanguageRow: View {
    let language: Language
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(language.flag).font(.system(size: 28))

                VStack(alignment: .leading, spacing: 2) {
                    Text(language.nativeName)
                        .font(.jakarta(17, weight: .bold))
                        .foregroundColor(.ink)
                    Text(language.nativeGreeting)
                        .font(.fraunces(14, weight: .light, italic: true))
                        .foregroundColor(.muted)
                }

                Spacer()

                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color.accent)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 68)
            .background(isSelected ? Color.accent.opacity(0.09) : Color.surface)
            .cornerRadius(Radius.card)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(isSelected ? Color.accent : Color.clear, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Corner Radius Helper

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
