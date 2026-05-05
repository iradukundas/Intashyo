// EmergencyView.swift — Screen 08

import SwiftUI

struct EmergencyView: View {
    @Environment(AppState.self) private var appState
    var onBack: (() -> Void)? = nil

    private var L: L { appState.L }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header
                HStack(alignment: .top, spacing: 12) {
                    if let back = onBack { BackButton(action: back) }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("🚨 \(L.emergency)")
                            .font(.fraunces(24, weight: .bold))
                            .foregroundColor(.ink)
                        Text(L.quickContacts)
                            .font(.jakarta(12))
                            .foregroundColor(.muted)
                    }
                    Spacer()
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, 16)

                // 911 Block
                VStack(spacing: 16) {
                    Text("911")
                        .font(.fraunces(64, weight: .bold))
                        .foregroundColor(.white)
                        .lineSpacing(0)

                    Text(L.emergencyServices)
                        .font(.jakarta(16, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)

                    HStack(spacing: 10) {
                        EmergencyActionButton(label: "📞 \(L.callPolice)") {
                            if let url = URL(string: "tel://911") {
                                UIApplication.shared.open(url)
                            }
                        }
                        EmergencyActionButton(label: "💬 \(L.textPolice)") {
                            if let url = URL(string: "sms://911") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color.appRed)
                .cornerRadius(20)
                .emergencyBlockShadow()
                .padding(.horizontal, Spacing.lg)

                // Other contacts
                SectionLabel(text: L.otherContacts)
                    .padding(.horizontal, Spacing.lg)

                VStack(spacing: 10) {
                    ForEach(EmergencyContact.all) { contact in
                        EmergencyContactCard(contact: contact, callLabel: L.call)
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, 24)
            }
        }
        .background(Color.bg.ignoresSafeArea())
    }
}

// MARK: - Emergency Action Button

struct EmergencyActionButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.jakarta(15, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Emergency Contact Card

struct EmergencyContactCard: View {
    let contact: EmergencyContact
    let callLabel: String

    var body: some View {
        HStack(spacing: 14) {
            CategoryBadge(
                emoji: contact.emoji,
                bgColor: contact.bgColor.swiftUIColor,
                size: 42,
                radius: 12,
                emojiSize: 20
            )

            VStack(alignment: .leading, spacing: 2) {
                Text(contact.titleKey)
                    .font(.jakarta(14, weight: .bold))
                    .foregroundColor(.ink)
                Text(contact.detail)
                    .font(.jakarta(12))
                    .foregroundColor(.muted)
            }

            Spacer()

            Button {
                let number = contact.number.filter { $0.isNumber }
                if let url = URL(string: "tel://\(number)") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text(callLabel)
                    .font(.jakarta(13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.accent)
                    .cornerRadius(10)
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 13)
        .background(Color.surface)
        .cornerRadius(Radius.card)
        .cardShadow()
    }
}
