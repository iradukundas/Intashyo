// MainTabView.swift — Tab bar shell + main navigation

import SwiftUI

enum AppTab: Int, CaseIterable {
    case home, resources, chat, emergency, profile
}

struct MainTabView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedTab: AppTab = .home

    private var L: L { appState.L }

    var body: some View {
        ZStack {
            // Screen content — safeAreaInset handles tab bar spacing + keyboard
            ZStack {
                homeView
                    .opacity(selectedTab == .home ? 1 : 0)
                    .allowsHitTesting(selectedTab == .home)

                resourcesView
                    .opacity(selectedTab == .resources ? 1 : 0)
                    .allowsHitTesting(selectedTab == .resources)

                chatView
                    .opacity(selectedTab == .chat ? 1 : 0)
                    .allowsHitTesting(selectedTab == .chat)

                emergencyView
                    .opacity(selectedTab == .emergency ? 1 : 0)
                    .allowsHitTesting(selectedTab == .emergency)

                ProfileView()
                    .opacity(selectedTab == .profile ? 1 : 0)
                    .allowsHitTesting(selectedTab == .profile)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                customTabBar
                    .ignoresSafeArea(.keyboard) // tab bar stays put when keyboard opens
            }

            // Language modal overlay — triggered from any tab via appState
            if appState.showLanguageModal {
                LanguageModalView(isPresented: Bindable(appState).showLanguageModal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.showLanguageModal)
        // Checklist sheet
        .sheet(isPresented: Bindable(appState).showChecklist) {
            ChecklistView(onDismiss: { appState.showChecklist = false })
                .environment(appState)
        }
        // Deep-link: when pendingResourceCategory is set from Home, switch to resources tab
        .onChange(of: appState.pendingResourceCategory) { _, cat in
            if cat != nil { selectedTab = .resources }
        }
    }

    // MARK: - Screen instances

    private var homeView: some View {
        HomeView(
            onNavigate: { tab in
                Haptics.impact(.light)
                selectedTab = tab
            },
            onCategoryTap: { cat in
                Haptics.impact(.light)
                appState.pendingResourceCategory = cat
                selectedTab = .resources
            }
        )
    }

    private var resourcesView: some View {
        ResourcesView(onBack: { selectedTab = .home })
    }

    private var chatView: some View {
        AIChatView(onBack: { selectedTab = .home })
    }

    private var emergencyView: some View {
        EmergencyView()
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        VStack(spacing: 0) {
            Divider().background(Color.faint)
            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.rawValue) { tab in
                    TabBarItem(
                        isSelected: selectedTab == tab,
                        label: tabLabel(tab),
                        icon: tabIcon(tab)
                    ) {
                        Haptics.impact(.light)
                        selectedTab = tab
                    }
                }
            }
            .padding(.horizontal, 4)
            .padding(.top, 8)
            .padding(.bottom, 20)
            .background(Color.surface)
        }
    }

    private func tabLabel(_ tab: AppTab) -> String {
        switch tab {
        case .home:      return L.tabHome
        case .resources: return L.tabResources
        case .chat:      return L.tabChat
        case .emergency: return L.tabEmergency
        case .profile:   return L.tabProfile
        }
    }

    private func tabIcon(_ tab: AppTab) -> String {
        let sel = selectedTab == tab
        switch tab {
        case .home:      return sel ? "house.fill"                        : "house"
        case .resources: return sel ? "square.grid.2x2.fill"              : "square.grid.2x2"
        case .chat:      return sel ? "bubble.left.and.bubble.right.fill"  : "bubble.left.and.bubble.right"
        case .emergency: return sel ? "exclamationmark.triangle.fill"      : "exclamationmark.triangle"
        case .profile:   return sel ? "person.fill"                       : "person"
        }
    }
}

// MARK: - Tab Bar Item

struct TabBarItem: View {
    let isSelected: Bool
    let label: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .accent : .muted)
                Text(label)
                    .font(.jakarta(10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .accent : .muted)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
