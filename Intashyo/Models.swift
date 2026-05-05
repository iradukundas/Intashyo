// Models.swift — Data models for resources and emergency contacts

import Foundation
import CoreLocation

// MARK: - Resource Category

enum ResourceCategory: String, CaseIterable, Identifiable {
    case housing, food, health, legal, jobs, documents

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .housing:   return "🏠"
        case .food:      return "🍎"
        case .health:    return "⚕️"
        case .legal:     return "⚖️"
        case .jobs:      return "💼"
        case .documents: return "📄"
        }
    }

    var color: ColorToken {
        switch self {
        case .housing:   return .blue
        case .food:      return .green
        case .health:    return .gold
        case .legal:     return .purple
        case .jobs:      return .blue
        case .documents: return .muted
        }
    }

    var bgColor: ColorToken {
        switch self {
        case .housing:   return .blueBg
        case .food:      return .greenBg
        case .health:    return .goldBg
        case .legal:     return .purpleBg
        case .jobs:      return .jobsBg
        case .documents: return .cream
        }
    }

    func localizedName(_ L: L) -> String {
        switch self {
        case .housing:   return L.catHousing
        case .food:      return L.catFood
        case .health:    return L.catHealth
        case .legal:     return L.catLegal
        case .jobs:      return L.catJobs
        case .documents: return L.catDocs
        }
    }
}

enum ColorToken {
    case blue, green, gold, purple, muted, jobsBg, blueBg, greenBg, goldBg, purpleBg, cream
}

// MARK: - Resource Provider

struct Resource: Identifiable {
    let id: String
    let category: ResourceCategory
    let name: String
    let note: String
    let phone: String
    let address: String
    let distanceMiles: Double
    let rating: Double
    let acceptsWalkIns: Bool
}

// MARK: - Sample Data

extension Resource {
    static let sampleData: [Resource] = [
        // Housing
        Resource(id: "h1", category: .housing, name: "Atlanta Housing Authority", note: "Section 8 & emergency housing", phone: "+14044540715", address: "230 John Wesley Dobbs Ave NE", distanceMiles: 1.2, rating: 4.2, acceptsWalkIns: true),
        Resource(id: "h2", category: .housing, name: "Covenant House Georgia", note: "Youth & family shelter", phone: "+14048756892", address: "1559 Johnson Rd NW", distanceMiles: 2.7, rating: 4.5, acceptsWalkIns: false),
        Resource(id: "h3", category: .housing, name: "Partners for HOME", note: "Rapid re-housing & prevention", phone: "+14043419038", address: "86 Pryor St SW", distanceMiles: 0.9, rating: 4.0, acceptsWalkIns: true),

        // Food
        Resource(id: "f1", category: .food, name: "Atlanta Community Food Bank", note: "SNAP enrollment & food pantry", phone: "+14043164700", address: "3400 N Desert Dr", distanceMiles: 4.1, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "f2", category: .food, name: "Open Hand Atlanta", note: "Meals for seniors & ill", phone: "+14048752246", address: "181 Armour Dr NE", distanceMiles: 2.3, rating: 4.6, acceptsWalkIns: true),
        Resource(id: "f3", category: .food, name: "DFCS Benefits Office", note: "SNAP, Medicaid applications", phone: "+14042064500", address: "910 Martin Luther King Jr Dr", distanceMiles: 1.8, rating: 3.9, acceptsWalkIns: false),

        // Health
        Resource(id: "he1", category: .health, name: "Grady Memorial Hospital", note: "Emergency & primary care", phone: "+14046160600", address: "80 Jesse Hill Jr Dr SE", distanceMiles: 0.8, rating: 4.1, acceptsWalkIns: true),
        Resource(id: "he2", category: .health, name: "Mercy Care Free Clinic", note: "Free for uninsured patients", phone: "+14046885550", address: "165 Boulevard NE", distanceMiles: 1.5, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "he3", category: .health, name: "Fulton County Health Dept", note: "Immunizations & screenings", phone: "+14046130200", address: "137 Peachtree St SW", distanceMiles: 0.6, rating: 3.8, acceptsWalkIns: true),

        // Legal
        Resource(id: "l1", category: .legal, name: "PAIR Project", note: "Free immigration legal aid", phone: "+14044633700", address: "11 Forsyth St SW", distanceMiles: 0.7, rating: 4.9, acceptsWalkIns: false),
        Resource(id: "l2", category: .legal, name: "Atlanta Legal Aid Society", note: "Civil legal aid for low-income", phone: "+14042233323", address: "54 Ellis St NE", distanceMiles: 0.5, rating: 4.4, acceptsWalkIns: true),
        Resource(id: "l3", category: .legal, name: "Catholic Charities Atlanta", note: "Immigration & refugee services", phone: "+14043255719", address: "2557 Habersham Rd NW", distanceMiles: 5.2, rating: 4.6, acceptsWalkIns: false),

        // Jobs
        Resource(id: "j1", category: .jobs, name: "Goodwill CareerLink Atlanta", note: "Job training & placement", phone: "+14043508501", address: "2201 Glenwood Ave", distanceMiles: 3.4, rating: 4.2, acceptsWalkIns: true),
        Resource(id: "j2", category: .jobs, name: "International Rescue Committee", note: "Refugee employment services", phone: "+14043800239", address: "1 Alliance Center, Suite 605", distanceMiles: 2.1, rating: 4.8, acceptsWalkIns: false),
        Resource(id: "j3", category: .jobs, name: "DWIHN WorkSource Atlanta", note: "Free job search & resume help", phone: "+14046990525", address: "818 Pollard Blvd SW", distanceMiles: 2.9, rating: 3.7, acceptsWalkIns: true),

        // Documents
        Resource(id: "d1", category: .documents, name: "Social Security Administration", note: "SSN cards & replacement", phone: "+18007721213", address: "401 W Peachtree St NW", distanceMiles: 1.0, rating: 3.5, acceptsWalkIns: false),
        Resource(id: "d2", category: .documents, name: "Georgia DDS (Driver Services)", note: "State ID & driver's license", phone: "+16783135000", address: "2206 Eastview Pkwy", distanceMiles: 6.3, rating: 3.6, acceptsWalkIns: true),
        Resource(id: "d3", category: .documents, name: "New American Pathways", note: "Immigration docs & translation", phone: "+14043992028", address: "5180 Snapfinger Woods Dr", distanceMiles: 8.1, rating: 4.7, acceptsWalkIns: false),
    ]

    static func forCategory(_ category: ResourceCategory) -> [Resource] {
        sampleData.filter { $0.category == category }
    }
}

// MARK: - Emergency Contact

struct EmergencyContact: Identifiable {
    let id = UUID()
    let emoji: String
    let titleKey: String  // display title
    let detail: String
    let color: ColorToken
    let bgColor: ColorToken
    let number: String
}

extension EmergencyContact {
    static let all: [EmergencyContact] = [
        EmergencyContact(emoji: "💬", titleKey: "Crisis Text Line",         detail: "Text HOME to 741741",   color: .green,  bgColor: .greenBg,  number: "741741"),
        EmergencyContact(emoji: "⚖️", titleKey: "Immigration Legal",        detail: "1-800-354-0365",         color: .blue,   bgColor: .blueBg,   number: "18003540365"),
        EmergencyContact(emoji: "🛡️", titleKey: "Domestic Violence Hotline", detail: "1-800-799-7233",        color: .purple, bgColor: .purpleBg, number: "18007997233"),
        EmergencyContact(emoji: "🏥", titleKey: "Nearest Hospital",         detail: "Grady Memorial ER",      color: .gold,   bgColor: .goldBg,   number: "+14046160600"),
        EmergencyContact(emoji: "🍎", titleKey: "Emergency Food",           detail: "1-877-423-4746",         color: .muted,  bgColor: .cream,    number: "18774234746"),
    ]
}
