// HomeView.swift — Screen 03

import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    var onNavigate: (AppTab) -> Void
    var onCategoryTap: (ResourceCategory) -> Void

    private var L: L { appState.L }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Group {
                            if appState.userName.isEmpty {
                                Text("\(L.greeting) 👋")
                            } else {
                                Text("\(L.greeting), \(appState.userName) 👋")
                            }
                        }
                        .font(.fraunces(28, weight: .bold, italic: true))
                        .foregroundColor(.ink)

                        Text("\(L.subGreeting) · \(L.tagline)")
                            .font(.jakarta(13))
                            .foregroundColor(.muted)
                    }
                    Spacer()
                    LanguagePill(language: appState.selectedLanguage) {
                        Haptics.impact(.light)
                        appState.showLanguageModal = true
                    }
                }
                .padding(.horizontal, Spacing.xl2)
                .padding(.top, Spacing.sm)

                // Arrival Checklist Banner
                Button {
                    Haptics.impact(.light)
                    appState.showChecklist = true
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 36, height: 36)
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L.checklist)
                                .font(.jakarta(14, weight: .bold))
                                .foregroundColor(.white)
                            // Dynamic subtitle: "X of 8 steps complete"
                            Text("\(appState.checklistCompletedCount) / \(checklistItems.count)")
                                .font(.jakarta(12))
                                .foregroundColor(.white.opacity(0.75))
                        }
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 36, height: 36)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.accent)
                    .cornerRadius(18)
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, Spacing.lg)

                // Section label
                SectionLabel(text: L.quickAccess)
                    .padding(.horizontal, Spacing.lg)

                // Category 2×3 grid — tapping opens that specific category
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(ResourceCategory.allCases) { cat in
                        CategoryCard(category: cat, L: L) {
                            onCategoryTap(cat)
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)

                // ESL Alert
                CardView {
                    HStack(spacing: 12) {
                        CategoryBadge(emoji: "📢", bgColor: .greenBg, size: 36, radius: 10, emojiSize: 18)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L.eslAlert)
                                .font(.jakarta(14, weight: .bold))
                                .foregroundColor(.appGreen)
                            Text(L.eslSub)
                                .font(.jakarta(12))
                                .foregroundColor(.muted)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, Spacing.lg)

                // AI Chat Entry
                Button { onNavigate(.chat) } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.accent)
                                .frame(width: 40, height: 40)
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(L.askAnything)
                                .font(.jakarta(15, weight: .bold))
                                .foregroundColor(.white)
                            Text(L.chatSub)
                                .font(.jakarta(12))
                                .foregroundColor(.white.opacity(0.55))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
                    .background(Color.ink)
                    .cornerRadius(18)
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, 24)
            }
        }
        .background(Color.bg.ignoresSafeArea())
    }
}

// MARK: - Category Card

struct CategoryCard: View {
    let category: ResourceCategory
    let L: L
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Text(category.emoji).font(.system(size: 26))
                Text(category.localizedName(L))
                    .font(.jakarta(15, weight: .bold))
                    .foregroundColor(category.color.swiftUIColor)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 16)
            .background(category.bgColor.swiftUIColor)
            .cornerRadius(Radius.category)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
