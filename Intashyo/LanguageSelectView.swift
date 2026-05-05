// LanguageSelectView.swift — Screen 01

import SwiftUI

struct LanguageSelectView: View {
    @Environment(AppState.self) private var appState
    var onSelected: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero block
                VStack(spacing: 12) {
                    LogoMark(size: 72)
                    Text("Intashyo")
                        .font(.fraunces(36, weight: .bold))
                        .foregroundColor(.ink)
                    Text("Murakaza neza · Bienvenue · Karibu")
                        .font(.jakarta(15))
                        .foregroundColor(.muted)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                .padding(.bottom, 36)

                // Section label
                SectionLabel(text: "Hitamo · Choisir · Chagua · Choose")
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)

                // Language rows
                VStack(spacing: 12) {
                    ForEach(Language.allCases) { lang in
                        LanguageRow(
                            language: lang,
                            isSelected: appState.selectedLanguage == lang
                        ) {
                            appState.switchLanguage(lang)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                onSelected()
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)

                // Footer
                Text("Izindi ndimi zizaza vuba · More languages coming soon")
                    .font(.jakarta(13))
                    .foregroundColor(.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.bg.ignoresSafeArea())
    }
}

// MARK: - Language Row

struct LanguageRow: View {
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

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.muted)
            }
            .padding(.horizontal, 18)
            .frame(height: 68)
            .background(Color.surface)
            .cornerRadius(Radius.card)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.card)
                    .stroke(isSelected ? Color.accent : Color.clear, lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
