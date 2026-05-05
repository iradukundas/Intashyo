// AppState.swift — Central app state, persisted to UserDefaults

import SwiftUI
import Observation

@Observable
final class AppState {
    var selectedLanguage: Language = .kinyarwanda
    var userName: String = ""
    var userCity: String = ""
    var durationInUS: Int? = nil
    var onboardingComplete: Bool = false
    var checklistProgress: [String: Bool] = [:]
    var savedResources: [String] = []
    // Used to deep-link from Home category cards → ResourcesView
    var pendingResourceCategory: ResourceCategory? = nil
    // Controls checklist sheet presentation from Home
    var showChecklist: Bool = false
    // Controls language modal — can be triggered from any tab
    var showLanguageModal: Bool = false

    var L: L { Intashyo.L(lang: selectedLanguage) }

    var checklistCompletedCount: Int {
        checklistItems.filter { checklistProgress[$0.id] == true }.count
    }

    init() { load() }

    func load() {
        if let raw = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let lang = Language(rawValue: raw) {
            selectedLanguage = lang
        }
        userName  = UserDefaults.standard.string(forKey: "userName") ?? ""
        userCity  = UserDefaults.standard.string(forKey: "userCity") ?? ""
        if let dur = UserDefaults.standard.object(forKey: "durationInUS") as? Int {
            durationInUS = dur
        }
        onboardingComplete = UserDefaults.standard.bool(forKey: "onboardingComplete")
        if let saved = UserDefaults.standard.dictionary(forKey: "checklistProgress") as? [String: Bool] {
            checklistProgress = saved
        }
    }

    func save() {
        UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(userCity, forKey: "userCity")
        if let dur = durationInUS { UserDefaults.standard.set(dur, forKey: "durationInUS") }
        UserDefaults.standard.set(onboardingComplete, forKey: "onboardingComplete")
        UserDefaults.standard.set(checklistProgress, forKey: "checklistProgress")
    }

    func completeOnboarding() {
        onboardingComplete = true
        save()
    }

    func switchLanguage(_ lang: Language) {
        selectedLanguage = lang
        save()
    }

    func toggleChecklist(_ id: String) {
        checklistProgress[id] = !(checklistProgress[id] ?? false)
        save()
    }
}
