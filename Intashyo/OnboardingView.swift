// OnboardingView.swift — Screen 02 (3 steps)

import SwiftUI
import MapKit

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    var onComplete: () -> Void
    var onBack: () -> Void = {}

    @State private var step: Int = 0
    @State private var name: String = ""
    @State private var selectedDuration: Int? = nil
    @State private var city: String = ""

    private var L: L { appState.L }

    var body: some View {
        VStack(spacing: 0) {
            // Top bar: back button + progress pills
            HStack(spacing: 14) {
                BackButton {
                    Haptics.impact()
                    if step == 0 {
                        onBack()
                    } else {
                        withAnimation { step -= 1 }
                    }
                }
                ProgressPills(filled: step + 1, total: 3)
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.top, 20)
            .padding(.bottom, 32)

            // Step content
            Group {
                switch step {
                case 0: nameStep
                case 1: durationStep
                default: cityStep
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
            .id(step)

            Spacer()
        }
        .background(Color.bg.ignoresSafeArea())
        .animation(.easeInOut(duration: 0.3), value: step)
    }

    // MARK: - Step 1: Name

    private var nameStep: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L.namePrompt)
                .font(.fraunces(26, weight: .bold))
                .foregroundColor(.ink)
            Text(L.namePromptSub)
                .font(.jakarta(14))
                .foregroundColor(.muted)
                .padding(.top, 8)

            TextField(L.namePlaceholder, text: $name)
                .font(.jakarta(16, weight: .medium))
                .textContentType(.givenName)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
                .padding(14)
                .background(Color.surface)
                .cornerRadius(Radius.input)
                .overlay(RoundedRectangle(cornerRadius: Radius.input).stroke(Color.faint, lineWidth: 1.5))
                .padding(.top, 28)

            PrimaryButton(label: name.isEmpty ? L.skipNow : L.getStarted) {
                Haptics.impact(.medium)
                if !name.isEmpty {
                    appState.userName = name
                    appState.save()
                }
                withAnimation { step = 1 }
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, Spacing.xl)
    }

    // MARK: - Step 2: Duration

    private var durationStep: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L.onboardQ1)
                .font(.fraunces(26, weight: .bold))
                .foregroundColor(.ink)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { idx in
                    let labels = [L.onboardA1_0, L.onboardA1_1, L.onboardA1_2]
                    DurationOption(
                        label: labels[idx],
                        isSelected: selectedDuration == idx
                    ) {
                        Haptics.impact(.light)
                        selectedDuration = idx
                        appState.durationInUS = idx
                        appState.save()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation { step = 2 }
                        }
                    }
                }
            }
            .padding(.top, 28)
        }
        .padding(.horizontal, Spacing.xl)
    }

    // MARK: - Step 3: City (with location autocomplete)

    private var cityStep: some View {
        CityStepView(city: $city, L: L) {
            Haptics.impact(.medium)
            if !city.isEmpty { appState.userCity = city }
            appState.completeOnboarding()
            onComplete()
        }
        .padding(.horizontal, Spacing.xl)
    }
}

// MARK: - City Step (separate view so it can own the @StateObject)

struct CityStepView: View {
    @Binding var city: String
    let L: L
    let onContinue: () -> Void

    @StateObject private var completer = LocationCompleter()
    @State private var showSuggestions = false
    @FocusState private var fieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(L.onboardQ2)
                .font(.fraunces(26, weight: .bold))
                .foregroundColor(.ink)

            // Input + suggestions
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: "mappin")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.muted)
                    TextField(L.onboardPlaceholder, text: $city)
                        .font(.jakarta(16, weight: .medium))
                        .textContentType(.addressCity)
                        .autocorrectionDisabled()
                        .focused($fieldFocused)
                        .onChange(of: city) { _, newVal in
                            completer.update(query: newVal)
                            showSuggestions = !newVal.isEmpty
                        }
                    if !city.isEmpty {
                        Button { city = ""; completer.clear(); showSuggestions = false } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.muted)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(14)
                .background(Color.surface)
                .cornerRadius(showSuggestions && !completer.suggestions.isEmpty ? Radius.input : Radius.input, corners: showSuggestions && !completer.suggestions.isEmpty ? [.topLeft, .topRight] : .allCorners)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.input)
                        .stroke(fieldFocused ? Color.accent : Color.faint, lineWidth: 1.5)
                )
                .animation(.easeInOut(duration: 0.15), value: fieldFocused)

                // Suggestions dropdown
                if showSuggestions && !completer.suggestions.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(Array(completer.suggestions.enumerated()), id: \.offset) { idx, suggestion in
                            Button {
                                city = suggestion
                                showSuggestions = false
                                completer.clear()
                                fieldFocused = false
                                Haptics.impact(.light)
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "mappin.circle")
                                        .font(.system(size: 14))
                                        .foregroundColor(.accent)
                                    Text(suggestion)
                                        .font(.jakarta(14))
                                        .foregroundColor(.ink)
                                        .lineLimit(1)
                                    Spacer()
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(.plain)

                            if idx < completer.suggestions.count - 1 {
                                Divider().padding(.leading, 14).background(Color.faint)
                            }
                        }
                    }
                    .background(Color.surface)
                    .cornerRadius(Radius.input, corners: [.bottomLeft, .bottomRight])
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.top, 28)
            .animation(.easeInOut(duration: 0.2), value: completer.suggestions.isEmpty)

            PrimaryButton(label: city.isEmpty ? L.skipNow : L.getStarted) {
                onContinue()
            }
            .padding(.top, 20)
        }
    }
}

// MARK: - Progress Pills

struct ProgressPills: View {
    let filled: Int
    let total: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(i < filled ? Color.accent : Color.faint)
                    .frame(height: 4)
                    .animation(.easeInOut(duration: 0.3), value: filled)
            }
        }
    }
}

// MARK: - Duration Option

struct DurationOption: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.accent : Color.faint, lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle()
                            .fill(Color.accent)
                            .frame(width: 10, height: 10)
                    }
                }
                Text(label)
                    .font(.jakarta(15, weight: .semibold))
                    .foregroundColor(.ink)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .background(isSelected ? Color.accent.opacity(0.09) : Color.surface)
            .cornerRadius(Radius.input)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.input)
                    .stroke(isSelected ? Color.accent : Color.faint, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
