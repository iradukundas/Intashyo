// ProfileView.swift — Screen 09 (placeholder, design TBD)

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    private var L: L { appState.L }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // Avatar
            ZStack {
                Circle()
                    .fill(Color.cream)
                    .frame(width: 96, height: 96)
                Text(appState.userName.prefix(1).uppercased().isEmpty ? "?" : String(appState.userName.prefix(1).uppercased()))
                    .font(.fraunces(40, weight: .bold))
                    .foregroundColor(.accent)
            }

            VStack(spacing: 6) {
                if !appState.userName.isEmpty {
                    Text(appState.userName)
                        .font(.fraunces(24, weight: .bold))
                        .foregroundColor(.ink)
                }
                if !appState.userCity.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.system(size: 12))
                            .foregroundColor(.muted)
                        Text(appState.userCity)
                            .font(.jakarta(14))
                            .foregroundColor(.muted)
                    }
                }
                HStack(spacing: 6) {
                    Text(appState.selectedLanguage.flag)
                    Text(appState.selectedLanguage.nativeName)
                        .font(.jakarta(13))
                        .foregroundColor(.muted)
                }
            }

            // Language selector shortcut
            Button {
                appState.showLanguageModal = true
            } label: {
                HStack {
                    Text(L.changeLang)
                        .font(.jakarta(15, weight: .semibold))
                        .foregroundColor(.accent)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.muted)
                }
                .padding(16)
                .background(Color.surface)
                .cornerRadius(Radius.card)
                .cardShadow()
            }
            .buttonStyle(.plain)
            .padding(.horizontal, Spacing.xl)

            Spacer()

            Text("Intashyo v1.0")
                .font(.jakarta(12))
                .foregroundColor(.muted)
                .padding(.bottom, 20)
        }
        .background(Color.bg.ignoresSafeArea())
    }
}
