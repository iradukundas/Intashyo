// ResourcesView.swift — Screen 05

import SwiftUI

struct ResourcesView: View {
    @Environment(AppState.self) private var appState
    var onBack: () -> Void

    @State private var searchText: String = ""
    @State private var selectedCategory: ResourceCategory? = nil

    private var L: L { appState.L }

    private var filteredCategories: [ResourceCategory] {
        if searchText.isEmpty { return ResourceCategory.allCases }
        return ResourceCategory.allCases.filter {
            $0.localizedName(L).localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if let cat = selectedCategory {
                ResourceDetailView(category: cat, L: L) {
                    withAnimation { selectedCategory = nil }
                } onAskAI: {
                    // Handled externally via tab switching if needed
                }
            } else {
                mainView
            }
        }
        // Respond to deep-link from Home category cards
        .onChange(of: appState.pendingResourceCategory) { _, cat in
            if let cat {
                selectedCategory = cat
                appState.pendingResourceCategory = nil
            }
        }
        .onAppear {
            if let cat = appState.pendingResourceCategory {
                selectedCategory = cat
                appState.pendingResourceCategory = nil
            }
        }
    }

    private var mainView: some View {
        VStack(spacing: 0) {
            // Header
            HStack(alignment: .top, spacing: 12) {
                BackButton(action: onBack)
                VStack(alignment: .leading, spacing: 2) {
                    Text(L.resources)
                        .font(.fraunces(24, weight: .bold))
                        .foregroundColor(.ink)
                    Text(L.findWhat)
                        .font(.jakarta(12))
                        .foregroundColor(.muted)
                }
                Spacer()
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, 16)
            .padding(.bottom, 16)

            // Search bar
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.muted)
                TextField(L.searchPlaceholder, text: $searchText)
                    .font(.jakarta(14))
                if !searchText.isEmpty {
                    Button { searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.muted)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 11)
            .background(Color.surface)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
            .padding(.horizontal, Spacing.lg)
            .padding(.bottom, 16)

            // Category list or empty state
            if filteredCategories.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Text("🔍").font(.system(size: 40))
                    Text(searchText)
                        .font(.fraunces(18, weight: .bold))
                        .foregroundColor(.ink)
                    Text("No categories match your search.")
                        .font(.jakarta(14))
                        .foregroundColor(.muted)
                }
                .frame(maxWidth: .infinity)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(filteredCategories) { cat in
                            ResourceCategoryRow(
                                category: cat,
                                L: L,
                                count: Resource.forCategory(cat).count
                            ) {
                                Haptics.impact(.light)
                                withAnimation { selectedCategory = cat }
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.bg.ignoresSafeArea())
    }
}

// MARK: - Category Row

struct ResourceCategoryRow: View {
    let category: ResourceCategory
    let L: L
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                CategoryBadge(
                    emoji: category.emoji,
                    bgColor: category.bgColor.swiftUIColor,
                    size: 48,
                    radius: 14,
                    emojiSize: 22
                )

                VStack(alignment: .leading, spacing: 3) {
                    Text(category.localizedName(L))
                        .font(.jakarta(16, weight: .bold))
                        .foregroundColor(.ink)
                    Text("\(count) \(L.resourcesAvailable)")
                        .font(.jakarta(12))
                        .foregroundColor(.muted)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.faint)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.surface)
            .cornerRadius(Radius.category)
            .cardShadow()
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
