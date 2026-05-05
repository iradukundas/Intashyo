// IntashyoApp.swift — App entry point and root navigation

import SwiftUI

@main
struct IntashyoApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
        }
    }
}

// MARK: - Root View (manages language select → onboarding → home flow)

struct RootView: View {
    @Environment(AppState.self) private var appState
    @State private var screen: RootScreen = .splash

    enum RootScreen {
        case splash
        case languageSelect
        case onboarding
        case main
    }

    var body: some View {
        Group {
            switch screen {
            case .splash:
                SplashView()
                    .onAppear { checkInitialScreen() }

            case .languageSelect:
                LanguageSelectView {
                    withAnimation { screen = .onboarding }
                }

            case .onboarding:
                OnboardingView(onComplete: {
                    withAnimation { screen = .main }
                }, onBack: {
                    withAnimation { screen = .languageSelect }
                })

            case .main:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.35), value: screen)
    }

    private func checkInitialScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if appState.onboardingComplete {
                screen = .main
            } else {
                let saved = UserDefaults.standard.string(forKey: "selectedLanguage")
                screen = (saved != nil) ? .onboarding : .languageSelect
            }
        }
    }
}

// MARK: - Splash View

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.7
    @State private var logoOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                LogoMark(size: 96)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                Text("Intashyo")
                    .font(.fraunces(36, weight: .bold))
                    .foregroundColor(.ink)
                    .padding(.top, 20)
                    .opacity(titleOpacity)

                Text("Murakaza neza · Bienvenue · Karibu")
                    .font(.jakarta(14))
                    .foregroundColor(.muted)
                    .padding(.top, 6)
                    .opacity(subtitleOpacity)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.7)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.35).delay(0.25)) {
                titleOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.35).delay(0.4)) {
                subtitleOpacity = 1.0
            }
        }
    }
}
