// ProfileView.swift — Screen 09

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    private var L: L { appState.L }

    private var savedResourceObjects: [Resource] {
        appState.savedResources.compactMap { Resource.find(id: $0) }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Avatar + info
                VStack(spacing: 28) {
                    ZStack {
                        Circle()
                            .fill(Color.cream)
                            .frame(width: 96, height: 96)
                        Text(appState.userName.prefix(1).uppercased().isEmpty
                             ? "?"
                             : String(appState.userName.prefix(1).uppercased()))
                            .font(.fraunces(40, weight: .bold))
                            .foregroundColor(.accent)
                    }
                    .padding(.top, 32)

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
                                Text(appState.displayCity)
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
                .padding(.top, 28)

                // Saved Resources
                if !savedResourceObjects.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionLabel(text: L.savedResources)
                            .padding(.horizontal, Spacing.lg)

                        VStack(spacing: 10) {
                            ForEach(savedResourceObjects) { resource in
                                SavedResourceRow(resource: resource, L: L) {
                                    Haptics.impact(.light)
                                    appState.toggleSave(resource.id)
                                }
                            }
                        }
                        .padding(.horizontal, Spacing.lg)
                    }
                    .padding(.top, 28)
                }

                Spacer(minLength: 32)

                Text("Intashyo v1.0")
                    .font(.jakarta(12))
                    .foregroundColor(.muted)
                    .padding(.bottom, 20)
            }
        }
        .background(Color.bg.ignoresSafeArea())
    }
}

// MARK: - Saved Resource Row

struct SavedResourceRow: View {
    let resource: Resource
    let L: L
    let onUnsave: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            CategoryBadge(
                emoji: resource.category.emoji,
                bgColor: resource.category.bgColor.swiftUIColor,
                size: 42,
                radius: 12,
                emojiSize: 20
            )

            VStack(alignment: .leading, spacing: 3) {
                Text(resource.name)
                    .font(.jakarta(14, weight: .bold))
                    .foregroundColor(.ink)
                    .lineLimit(1)
                Text(resource.note)
                    .font(.jakarta(12))
                    .foregroundColor(.muted)
                    .lineLimit(1)
            }

            Spacer()

            HStack(spacing: 8) {
                // Call
                Button {
                    if let url = URL(string: "tel://\(resource.phone.filter { $0.isNumber })") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.accent)
                        .clipShape(Circle())
                }
                .buttonStyle(ScaleButtonStyle())

                // Unsave
                Button(action: onUnsave) {
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.muted)
                        .frame(width: 32, height: 32)
                        .background(Color.surface)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.faint, lineWidth: 1))
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color.surface)
        .cornerRadius(Radius.card)
        .cardShadow()
    }
}
