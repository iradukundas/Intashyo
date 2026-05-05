// ResourceDetailView.swift — Screen 06

import SwiftUI

struct ResourceDetailView: View {
    let category: ResourceCategory
    let L: L
    var onBack: () -> Void
    var onAskAI: (() -> Void)? = nil

    private var providers: [Resource] { Resource.forCategory(category) }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(alignment: .top, spacing: 12) {
                BackButton(action: onBack)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(category.emoji) \(category.localizedName(L))")
                        .font(.fraunces(22, weight: .bold))
                        .foregroundColor(.ink)
                    Text("\(L.nearYou) · Atlanta, GA")
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
                        ProviderCard(resource: provider, L: L)
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

            // Location row
            HStack(spacing: 5) {
                Image(systemName: "mappin")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.muted)
                Text(String(format: "%.1f mi %@", resource.distanceMiles, L.away))
                    .font(.jakarta(12))
                    .foregroundColor(.muted)
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

                // Save
                Button {} label: {
                    Text(L.save)
                        .font(.jakarta(14, weight: .semibold))
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
        .padding(16)
        .background(Color.surface)
        .cornerRadius(Radius.card)
        .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
    }
}
