// ChecklistView.swift — New arrival checklist screen

import SwiftUI

struct ChecklistItem: Identifiable {
    let id: String
    let emoji: String
    let category: ResourceCategory
    let titleEN: String
    let titles: [String: String]  // lang code → title

    func title(for lang: Language) -> String {
        switch lang {
        case .kinyarwanda: return titles["rw"] ?? titleEN
        case .french:      return titles["fr"] ?? titleEN
        case .swahili:     return titles["sw"] ?? titleEN
        case .english:     return titleEN
        }
    }
}

let checklistItems: [ChecklistItem] = [
    ChecklistItem(id: "ssn",   emoji: "🪪", category: .documents, titleEN: "Get your Social Security Number",
                  titles: ["rw": "Kubona inomero ya Securité Sociale", "fr": "Obtenir votre numéro de sécurité sociale",
                            "sw": "Pata nambari ya Hifadhi ya Jamii"]),
    ChecklistItem(id: "bank",  emoji: "🏦", category: .documents, titleEN: "Open a bank account",
                  titles: ["rw": "Gufungura konti ya banki", "fr": "Ouvrir un compte bancaire",
                            "sw": "Fungua akaunti ya benki"]),
    ChecklistItem(id: "id",    emoji: "🪪", category: .documents, titleEN: "Apply for state ID or driver's license",
                  titles: ["rw": "Gusaba indangamuntu y'leta", "fr": "Demander une pièce d'identité ou un permis",
                            "sw": "Omba kitambulisho cha jimbo"]),
    ChecklistItem(id: "health",emoji: "🏥", category: .health,    titleEN: "Enroll in health insurance or Medicaid",
                  titles: ["rw": "Kwandikisha mu bima y'ubuzima", "fr": "S'inscrire à une assurance maladie",
                            "sw": "Jiandikisha kwa bima ya afya"]),
    ChecklistItem(id: "snap",  emoji: "🍎", category: .food,      titleEN: "Apply for SNAP food benefits",
                  titles: ["rw": "Gusaba ubufasha bw'ibiribwa (SNAP)", "fr": "Demander les aides alimentaires SNAP",
                            "sw": "Omba msaada wa chakula wa SNAP"]),
    ChecklistItem(id: "house", emoji: "🏠", category: .housing,   titleEN: "Find housing assistance",
                  titles: ["rw": "Gushaka ubufasha bw'inzu", "fr": "Trouver une aide au logement",
                            "sw": "Tafuta msaada wa makazi"]),
    ChecklistItem(id: "school",emoji: "🎒", category: .documents, titleEN: "Register children for school",
                  titles: ["rw": "Kwandikisha abana mu ishuri", "fr": "Inscrire les enfants à l'école",
                            "sw": "Sajili watoto shuleni"]),
    ChecklistItem(id: "esl",   emoji: "📚", category: .health,    titleEN: "Find an ESL class",
                  titles: ["rw": "Gushaka amasomo y'Icyongereza", "fr": "Trouver un cours d'anglais",
                            "sw": "Tafuta darasa la Kiingereza"]),
]

struct ChecklistView: View {
    @Environment(AppState.self) private var appState
    var onDismiss: () -> Void

    private var L: L { appState.L }
    private var completedCount: Int { checklistItems.filter { appState.checklistProgress[$0.id] == true }.count }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(alignment: .top, spacing: 12) {
                BackButton(action: onDismiss)
                VStack(alignment: .leading, spacing: 2) {
                    Text(L.checklist)
                        .font(.fraunces(24, weight: .bold))
                        .foregroundColor(.ink)
                    Text("\(completedCount)/\(checklistItems.count)")
                        .font(.jakarta(12))
                        .foregroundColor(.muted)
                }
                Spacer()
            }
            .padding(.horizontal, Spacing.lg)
            .padding(.top, 16)
            .padding(.bottom, 12)

            // Progress bar
            ProgressPills(filled: completedCount, total: checklistItems.count)
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, 20)

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(checklistItems) { item in
                        ChecklistRow(item: item, isChecked: appState.checklistProgress[item.id] == true) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                let current = appState.checklistProgress[item.id] == true
                                appState.checklistProgress[item.id] = !current
                                UserDefaults.standard.set(appState.checklistProgress, forKey: "checklistProgress")
                            }
                            Haptics.impact(.light)
                        }
                    }
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.bottom, 24)
            }
        }
        .background(Color.bg.ignoresSafeArea())
        .onAppear {
            if let saved = UserDefaults.standard.dictionary(forKey: "checklistProgress") as? [String: Bool] {
                appState.checklistProgress = saved
            }
        }
    }
}

struct ChecklistRow: View {
    let item: ChecklistItem
    let isChecked: Bool
    let action: () -> Void
    @Environment(AppState.self) private var appState

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Checkbox
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isChecked ? Color.accent : Color.surface)
                        .frame(width: 24, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isChecked ? Color.accent : Color.faint, lineWidth: 1.5)
                        )
                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                // Emoji + title
                HStack(spacing: 10) {
                    Text(item.emoji).font(.system(size: 20))
                    Text(item.title(for: appState.selectedLanguage))
                        .font(.jakarta(14, weight: isChecked ? .medium : .semibold))
                        .foregroundColor(isChecked ? .muted : .ink)
                        .strikethrough(isChecked, color: .muted)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                // Category color dot
                Circle()
                    .fill(item.category.color.swiftUIColor)
                    .frame(width: 8, height: 8)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(isChecked ? Color.cream : Color.surface)
            .cornerRadius(Radius.card)
            .cardShadow()
        }
        .buttonStyle(ScaleButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isChecked)
    }
}
