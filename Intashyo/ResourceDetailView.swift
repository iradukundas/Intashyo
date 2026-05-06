// ResourceDetailView.swift — Screen 06

import SwiftUI

struct ResourceDetailView: View {
    @Environment(AppState.self) private var appState
    let category: ResourceCategory
    let L: L
    var onBack: () -> Void
    var onAskAI: (() -> Void)? = nil

    private var providers: [Resource] {
        Resource.forCategory(category, city: appState.userCity)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(alignment: .top, spacing: 12) {
                BackButton(action: onBack)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(category.emoji) \(category.localizedName(L))")
                        .font(.fraunces(22, weight: .bold))
                        .foregroundColor(.ink)
                    Text(appState.userCity.isEmpty
                         ? L.nearYou
                         : "\(L.nearYou) · \(appState.displayCity)")
                        .font(.jakarta(12))
                        .foregroundColor(.muted)
                }
                Spacer()
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, 16)
            .padding(.bottom, 16)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(providers) { provider in
                        ProviderCard(
                            resource: provider,
                            L: L,
                            isSaved: appState.isSaved(provider.id)
                        ) {
                            Haptics.impact(.light)
                            appState.toggleSave(provider.id)
                        }
                    }

                    // Ask AI strip
                    Button(action: { onAskAI?() }) {
                        HStack(spacing: 12) {
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(category.color.swiftUIColor)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(L.askAiAbout) \(category.localizedName(L))")
                                    .font(.jakarta(14, weight: .bold))
                                    .foregroundColor(category.color.swiftUIColor)
                                Text(L.chatSub)
                                    .font(.jakarta(12))
                                    .foregroundColor(.muted)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(category.bgColor.swiftUIColor)
                        .cornerRadius(Radius.category)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.category)
                                .stroke(category.color.swiftUIColor.opacity(0.13), lineWidth: 1)
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, Spacing.lg)
            }
        }
        .background(Color.bg.ignoresSafeArea())
    }
}

// MARK: - Provider Card

struct ProviderCard: View {
    let resource: Resource
    let L: L
    let isSaved: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header row
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(resource.name)
                        .font(.jakarta(16, weight: .bold))
                        .foregroundColor(.ink)
                    Text(resource.note)
                        .font(.jakarta(12))
                        .foregroundColor(.muted)
                }
                Spacer()
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#f5a623"))
                    Text(String(format: "%.1f", resource.rating))
                        .font(.jakarta(12, weight: .semibold))
                        .foregroundColor(.muted)
                }
            }

            // Location row (only show distance when known)
            if resource.distanceMiles > 0 {
                HStack(spacing: 5) {
                    Image(systemName: "mappin")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.muted)
                    Text(String(format: "%.1f mi %@", resource.distanceMiles, L.away))
                        .font(.jakarta(12))
                        .foregroundColor(.muted)
                }
            } else {
                HStack(spacing: 5) {
                    Image(systemName: "mappin")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.muted)
                    Text(resource.address.components(separatedBy: ",").prefix(2).joined(separator: ","))
                        .font(.jakarta(12))
                        .foregroundColor(.muted)
                        .lineLimit(1)
                }
            }

            // Action buttons
            HStack(spacing: 8) {
                // Call
                Button {
                    if let url = URL(string: "tel://\(resource.phone.filter { $0.isNumber })") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label(L.call, systemImage: "phone")
                        .font(.jakarta(14, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.accent)
                        .cornerRadius(10)
                }
                .buttonStyle(ScaleButtonStyle())

                // Directions
                Button {
                    let query = resource.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    if let url = URL(string: "maps://?q=\(query)") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Label(L.directions, systemImage: "mappin")
                        .font(.jakarta(14, weight: .semibold))
                        .foregroundColor(.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.surface)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.faint, lineWidth: 1))
                }
                .buttonStyle(ScaleButtonStyle())

                // Save / bookmark
                Button(action: onSave) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSaved ? .accent : .ink)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(Color.surface)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.faint, lineWidth: 1))
                        .animation(.easeInOut(duration: 0.15), value: isSaved)
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(16)
        .background(Color.surface)
        .cornerRadius(Radius.card)
        .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
    }
}
