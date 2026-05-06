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
    let distanceMiles: Double   // 0 = unknown / distance not applicable
    let rating: Double
    let acceptsWalkIns: Bool
}

// MARK: - City-Aware Resource Lookup

extension Resource {

    /// Returns the internal city key for a user location string, or nil if unrecognized.
    static func cityKey(for location: String) -> String? {
        let s = location.lowercased()
        if s.contains("atlanta")                                           { return "atlanta"     }
        if s.contains("new york") || s.contains("brooklyn") ||
           s.contains("manhattan") || s.contains("bronx") ||
           s.contains("queens") || s.contains("staten island")            { return "new_york"    }
        if s.contains("minneapolis") || s.contains("saint paul") ||
           s.contains("st. paul") || s.contains("st paul")                { return "minneapolis" }
        if s.contains("houston")                                           { return "houston"     }
        if s.contains("washington, d") || s.contains(" dc") ||
           s.contains("washington dc") || s.contains("d.c.")              { return "dc"          }
        if s.contains("columbus")                                          { return "columbus"    }
        return nil
    }

    /// Display city label for a location string (first comma-delimited component).
    static func displayCity(for location: String) -> String {
        location.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? location
    }

    /// Resources for a category, filtered to the user's city.
    /// Falls back to Atlanta when no city is recognised.
    static func forCategory(_ category: ResourceCategory, city: String = "") -> [Resource] {
        let key = cityKey(for: city) ?? (city.isEmpty ? "atlanta" : nil)
        let pool = byCity[key ?? "atlanta"] ?? byCity["atlanta"]!
        return pool.filter { $0.category == category }
    }

    /// All resources for a city (all categories).
    static func forCity(_ city: String) -> [Resource] {
        let key = cityKey(for: city) ?? "atlanta"
        return byCity[key] ?? byCity["atlanta"]!
    }

    /// Look up a resource by ID across all cities.
    static func find(id: String) -> Resource? {
        byCity.values.flatMap { $0 }.first { $0.id == id }
    }

    // MARK: - City Data

    static let byCity: [String: [Resource]] = [
        "atlanta":     atlantaResources,
        "new_york":    newYorkResources,
        "minneapolis": minneapolisResources,
        "houston":     houstonResources,
        "dc":          dcResources,
        "columbus":    columbusResources,
    ]

    // MARK: Atlanta, GA

    static let atlantaResources: [Resource] = [
        // Housing
        Resource(id: "atl-h1", category: .housing, name: "Atlanta Housing Authority",   note: "Section 8 & emergency housing",      phone: "+14044540715", address: "230 John Wesley Dobbs Ave NE",    distanceMiles: 1.2, rating: 4.2, acceptsWalkIns: true),
        Resource(id: "atl-h2", category: .housing, name: "Covenant House Georgia",      note: "Youth & family shelter",             phone: "+14048756892", address: "1559 Johnson Rd NW",             distanceMiles: 2.7, rating: 4.5, acceptsWalkIns: false),
        Resource(id: "atl-h3", category: .housing, name: "Partners for HOME",           note: "Rapid re-housing & prevention",      phone: "+14043419038", address: "86 Pryor St SW",                 distanceMiles: 0.9, rating: 4.0, acceptsWalkIns: true),
        // Food
        Resource(id: "atl-f1", category: .food,    name: "Atlanta Community Food Bank", note: "SNAP enrollment & food pantry",      phone: "+14043164700", address: "3400 N Desert Dr",               distanceMiles: 4.1, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "atl-f2", category: .food,    name: "Open Hand Atlanta",           note: "Meals for seniors & ill",            phone: "+14048752246", address: "181 Armour Dr NE",               distanceMiles: 2.3, rating: 4.6, acceptsWalkIns: true),
        Resource(id: "atl-f3", category: .food,    name: "DFCS Benefits Office",        note: "SNAP & Medicaid applications",       phone: "+14042064500", address: "910 Martin Luther King Jr Dr",   distanceMiles: 1.8, rating: 3.9, acceptsWalkIns: false),
        // Health
        Resource(id: "atl-he1", category: .health, name: "Grady Memorial Hospital",    note: "Emergency & primary care",           phone: "+14046160600", address: "80 Jesse Hill Jr Dr SE",         distanceMiles: 0.8, rating: 4.1, acceptsWalkIns: true),
        Resource(id: "atl-he2", category: .health, name: "Mercy Care Free Clinic",     note: "Free for uninsured patients",        phone: "+14046885550", address: "165 Boulevard NE",               distanceMiles: 1.5, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "atl-he3", category: .health, name: "Fulton County Health Dept",  note: "Immunizations & screenings",         phone: "+14046130200", address: "137 Peachtree St SW",            distanceMiles: 0.6, rating: 3.8, acceptsWalkIns: true),
        // Legal
        Resource(id: "atl-l1", category: .legal,   name: "PAIR Project",               note: "Free immigration legal aid",         phone: "+14044633700", address: "11 Forsyth St SW",               distanceMiles: 0.7, rating: 4.9, acceptsWalkIns: false),
        Resource(id: "atl-l2", category: .legal,   name: "Atlanta Legal Aid Society",  note: "Civil legal aid for low-income",     phone: "+14042233323", address: "54 Ellis St NE",                 distanceMiles: 0.5, rating: 4.4, acceptsWalkIns: true),
        Resource(id: "atl-l3", category: .legal,   name: "Catholic Charities Atlanta", note: "Immigration & refugee services",     phone: "+14043255719", address: "2557 Habersham Rd NW",           distanceMiles: 5.2, rating: 4.6, acceptsWalkIns: false),
        // Jobs
        Resource(id: "atl-j1", category: .jobs,    name: "Goodwill CareerLink Atlanta",  note: "Job training & placement",         phone: "+14043508501", address: "2201 Glenwood Ave",              distanceMiles: 3.4, rating: 4.2, acceptsWalkIns: true),
        Resource(id: "atl-j2", category: .jobs,    name: "International Rescue Committee", note: "Refugee employment services",    phone: "+14043800239", address: "1 Alliance Center, Suite 605",   distanceMiles: 2.1, rating: 4.8, acceptsWalkIns: false),
        Resource(id: "atl-j3", category: .jobs,    name: "WorkSource Atlanta",          note: "Free job search & resume help",     phone: "+14046990525", address: "818 Pollard Blvd SW",            distanceMiles: 2.9, rating: 3.7, acceptsWalkIns: true),
        // Documents
        Resource(id: "atl-d1", category: .documents, name: "Social Security Administration", note: "SSN cards & replacement",     phone: "+18007721213", address: "401 W Peachtree St NW",          distanceMiles: 1.0, rating: 3.5, acceptsWalkIns: false),
        Resource(id: "atl-d2", category: .documents, name: "Georgia DDS (Driver Services)",   note: "State ID & driver's license", phone: "+16783135000", address: "2206 Eastview Pkwy",             distanceMiles: 6.3, rating: 3.6, acceptsWalkIns: true),
        Resource(id: "atl-d3", category: .documents, name: "New American Pathways",           note: "Immigration docs & translation", phone: "+14043992028", address: "5180 Snapfinger Woods Dr",   distanceMiles: 8.1, rating: 4.7, acceptsWalkIns: false),
    ]

    // MARK: New York, NY

    static let newYorkResources: [Resource] = [
        // Housing
        Resource(id: "nyc-h1", category: .housing, name: "NYC Housing Authority (NYCHA)",    note: "Public housing & Section 8 vouchers",   phone: "+18664664653", address: "250 Broadway, New York, NY",        distanceMiles: 1.1, rating: 3.8, acceptsWalkIns: true),
        Resource(id: "nyc-h2", category: .housing, name: "Neighborhood Housing Services NYC", note: "Affordable housing counseling",         phone: "+12126543130", address: "307 W 36th St, New York, NY",       distanceMiles: 2.0, rating: 4.4, acceptsWalkIns: true),
        Resource(id: "nyc-h3", category: .housing, name: "The Doe Fund",                     note: "Housing for at-risk men & immigrants",  phone: "+12126279550", address: "232 E 84th St, New York, NY",       distanceMiles: 3.2, rating: 4.5, acceptsWalkIns: false),
        // Food
        Resource(id: "nyc-f1", category: .food,    name: "City Harvest",                     note: "Food rescue & emergency food pantries", phone: "+21266364600", address: "150 52nd St, Brooklyn, NY",         distanceMiles: 4.5, rating: 4.9, acceptsWalkIns: true),
        Resource(id: "nyc-f2", category: .food,    name: "Food Bank for New York City",       note: "SNAP enrollment & food distribution",  phone: "+21266364600", address: "39 Broadway, Suite 1540, NY",       distanceMiles: 0.9, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "nyc-f3", category: .food,    name: "Catholic Charities Emergency Food", note: "Walk-in pantry, no appointment needed", phone: "+21263126800", address: "191 Joralemon St, Brooklyn, NY",   distanceMiles: 2.6, rating: 4.3, acceptsWalkIns: true),
        // Health
        Resource(id: "nyc-he1", category: .health, name: "Bellevue Hospital Center",         note: "Emergency, primary & immigrant care",  phone: "+12125622400", address: "462 1st Ave, New York, NY",         distanceMiles: 1.8, rating: 4.2, acceptsWalkIns: true),
        Resource(id: "nyc-he2", category: .health, name: "Ryan Health",                       note: "Sliding-scale community health center", phone: "+12126630400", address: "110 W 97th St, New York, NY",      distanceMiles: 4.1, rating: 4.6, acceptsWalkIns: true),
        Resource(id: "nyc-he3", category: .health, name: "NYC Health + Hospitals/Elmhurst",  note: "Free & low-cost care, multilingual",   phone: "+17189343000", address: "79-01 Broadway, Elmhurst, NY",     distanceMiles: 6.2, rating: 4.0, acceptsWalkIns: true),
        // Legal
        Resource(id: "nyc-l1", category: .legal,   name: "Legal Aid Society NY",             note: "Free civil & immigration legal aid",   phone: "+21264984200", address: "199 Water St, New York, NY",        distanceMiles: 0.8, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "nyc-l2", category: .legal,   name: "NY Legal Assistance Group (NYLAG)", note: "Free immigration & civil legal help", phone: "+21264914303", address: "100 William St, New York, NY",      distanceMiles: 0.6, rating: 4.7, acceptsWalkIns: false),
        Resource(id: "nyc-l3", category: .legal,   name: "Catholic Migration Services",       note: "Immigration & refugee legal services", phone: "+17187228060", address: "191 Joralemon St, Brooklyn, NY",   distanceMiles: 3.5, rating: 4.9, acceptsWalkIns: false),
        // Jobs
        Resource(id: "nyc-j1", category: .jobs,    name: "Workforce1 Career Center",          note: "Free job placement & training",        phone: "+18773723669", address: "168 W 132nd St, New York, NY",     distanceMiles: 5.0, rating: 4.1, acceptsWalkIns: true),
        Resource(id: "nyc-j2", category: .jobs,    name: "IRC New York",                      note: "Refugee employment & integration",     phone: "+21272799333", address: "One MetroTech Center, Brooklyn",   distanceMiles: 3.8, rating: 4.7, acceptsWalkIns: false),
        Resource(id: "nyc-j3", category: .jobs,    name: "Henry Street Settlement",            note: "Job training for immigrants & youth",  phone: "+21247855400", address: "265 Henry St, New York, NY",       distanceMiles: 1.4, rating: 4.5, acceptsWalkIns: true),
        // Documents
        Resource(id: "nyc-d1", category: .documents, name: "SSA — Midtown Manhattan Office",  note: "Social Security cards & benefits",     phone: "+18007721213", address: "123 W 57th St, New York, NY",      distanceMiles: 2.3, rating: 3.6, acceptsWalkIns: false),
        Resource(id: "nyc-d2", category: .documents, name: "NY DMV — 34th St Office",         note: "State ID & driver's license",          phone: "+17185317870", address: "159 E 125th St, New York, NY",     distanceMiles: 4.0, rating: 3.4, acceptsWalkIns: true),
        Resource(id: "nyc-d3", category: .documents, name: "USCIS New York Field Office",     note: "Green card, citizenship, asylum",       phone: "+18003752444", address: "26 Federal Plaza, New York, NY",   distanceMiles: 0.7, rating: 3.8, acceptsWalkIns: false),
    ]

    // MARK: Minneapolis, MN

    static let minneapolisResources: [Resource] = [
        // Housing
        Resource(id: "msp-h1", category: .housing, name: "Minneapolis Public Housing Authority", note: "Public housing & rental assistance",  phone: "+16123424400", address: "1001 Washington Ave N, Minneapolis", distanceMiles: 1.0, rating: 3.9, acceptsWalkIns: true),
        Resource(id: "msp-h2", category: .housing, name: "Aeon",                                note: "Affordable apartments & family housing", phone: "+16128742000", address: "901 N 3rd St, Minneapolis, MN",     distanceMiles: 1.3, rating: 4.5, acceptsWalkIns: false),
        Resource(id: "msp-h3", category: .housing, name: "CommonBond Communities",              note: "Affordable housing for immigrants",    phone: "+16512911750", address: "328 Kellogg Blvd W, St Paul, MN",   distanceMiles: 6.1, rating: 4.4, acceptsWalkIns: false),
        // Food
        Resource(id: "msp-f1", category: .food,    name: "Second Harvest Heartland",           note: "Twin Cities food bank network",        phone: "+16516966994", address: "7101 Winnetka Ave N, Brooklyn Park", distanceMiles: 9.2, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "msp-f2", category: .food,    name: "Islamic Civic Society of MN",        note: "Halal food shelf — walk-in welcome",   phone: "+16126224000", address: "1810 Plymouth Ave N, Minneapolis",  distanceMiles: 2.4, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "msp-f3", category: .food,    name: "Pillsbury United Communities",       note: "SNAP outreach & emergency food",       phone: "+16125211073", address: "1101 W Broadway, Minneapolis, MN",  distanceMiles: 2.1, rating: 4.3, acceptsWalkIns: true),
        // Health
        Resource(id: "msp-he1", category: .health, name: "Hennepin Healthcare",               note: "County hospital, multilingual care",    phone: "+16128731233", address: "701 Park Ave, Minneapolis, MN",     distanceMiles: 0.9, rating: 4.2, acceptsWalkIns: true),
        Resource(id: "msp-he2", category: .health, name: "Open Cities Health Center",          note: "Low-cost primary care, sliding scale",  phone: "+16516412800", address: "409 Dunlap St N, St Paul, MN",      distanceMiles: 5.8, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "msp-he3", category: .health, name: "Neighborhood HealthSource",          note: "Free & low-cost community clinic",      phone: "+16125881811", address: "2318 1st St N, Minneapolis, MN",    distanceMiles: 1.7, rating: 4.6, acceptsWalkIns: true),
        // Legal
        Resource(id: "msp-l1", category: .legal,   name: "Mid-Minnesota Legal Aid",           note: "Free civil & immigration legal aid",   phone: "+16123398855", address: "111 Nicollet Mall, Minneapolis, MN", distanceMiles: 0.4, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "msp-l2", category: .legal,   name: "The Advocates for Human Rights",    note: "Refugee & immigrant rights legal aid", phone: "+16123413302", address: "330 2nd Ave S, Minneapolis, MN",    distanceMiles: 0.6, rating: 4.9, acceptsWalkIns: false),
        Resource(id: "msp-l3", category: .legal,   name: "Catholic Charities — Legal Services", note: "Immigration & asylum legal help",     phone: "+16516410526", address: "162 Hamline Ave S, St Paul, MN",    distanceMiles: 5.3, rating: 4.5, acceptsWalkIns: false),
        // Jobs
        Resource(id: "msp-j1", category: .jobs,    name: "Emerge Community Development",      note: "Job training for East Africans",        phone: "+16123024020", address: "1516 E Lake St, Minneapolis, MN",   distanceMiles: 2.8, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "msp-j2", category: .jobs,    name: "Summit Academy OIC",                note: "Free vocational training programs",     phone: "+16127730900", address: "935 Olson Memorial Hwy, Minneapolis", distanceMiles: 2.1, rating: 4.6, acceptsWalkIns: true),
        Resource(id: "msp-j3", category: .jobs,    name: "Minnesota Department of Employment", note: "Job search, resume & career services", phone: "+16512593595", address: "1 W Water St, St Paul, MN",         distanceMiles: 6.0, rating: 3.9, acceptsWalkIns: true),
        // Documents
        Resource(id: "msp-d1", category: .documents, name: "SSA — Minneapolis Office",       note: "Social Security cards & benefits",      phone: "+18007721213", address: "100 N 6th St, Minneapolis, MN",     distanceMiles: 0.5, rating: 3.7, acceptsWalkIns: false),
        Resource(id: "msp-d2", category: .documents, name: "MN Driver & Vehicle Services",   note: "State ID, driver's license, tabs",      phone: "+16512976124", address: "445 Minnesota St, St Paul, MN",     distanceMiles: 5.9, rating: 3.5, acceptsWalkIns: true),
        Resource(id: "msp-d3", category: .documents, name: "Karen Organization of MN",        note: "Document help & interpretation",        phone: "+16512241001", address: "1105 Arcade St, St Paul, MN",       distanceMiles: 6.5, rating: 4.8, acceptsWalkIns: true),
    ]

    // MARK: Houston, TX

    static let houstonResources: [Resource] = [
        // Housing
        Resource(id: "hou-h1", category: .housing, name: "Houston Housing Authority",    note: "Section 8 & public housing waitlist",  phone: "+17136438400", address: "2640 Fountain View Dr, Houston, TX",  distanceMiles: 3.2, rating: 3.8, acceptsWalkIns: true),
        Resource(id: "hou-h2", category: .housing, name: "Avenue CDC",                  note: "Affordable homeownership & rentals",   phone: "+17133283080", address: "2213 Northwest Fwy, Houston, TX",     distanceMiles: 2.8, rating: 4.3, acceptsWalkIns: false),
        Resource(id: "hou-h3", category: .housing, name: "Star of Hope Mission",         note: "Emergency shelter & transitional housing", phone: "+17132239946", address: "6897 Ardmore St, Houston, TX",    distanceMiles: 5.4, rating: 4.4, acceptsWalkIns: true),
        // Food
        Resource(id: "hou-f1", category: .food,    name: "Houston Food Bank",            note: "Largest food bank in the US",          phone: "+17134337620", address: "535 Portwall St, Houston, TX",       distanceMiles: 3.1, rating: 4.9, acceptsWalkIns: true),
        Resource(id: "hou-f2", category: .food,    name: "Bread of Life",                note: "Hot meals & food pantry daily",        phone: "+17133692001", address: "2003 Congress Ave, Houston, TX",     distanceMiles: 1.2, rating: 4.5, acceptsWalkIns: true),
        Resource(id: "hou-f3", category: .food,    name: "BakerRipley SNAP Outreach",   note: "SNAP enrollment & benefit navigation", phone: "+17139572424", address: "6500 Rookin St, Houston, TX",        distanceMiles: 4.8, rating: 4.4, acceptsWalkIns: true),
        // Health
        Resource(id: "hou-he1", category: .health, name: "Harris Health — Ben Taub",    note: "Charity care hospital, multilingual",  phone: "+17138734000", address: "1504 Taub Loop, Houston, TX",        distanceMiles: 1.5, rating: 4.3, acceptsWalkIns: true),
        Resource(id: "hou-he2", category: .health, name: "Legacy Community Health",      note: "Sliding-scale FQHC, many languages",  phone: "+18328402400", address: "1415 California St, Houston, TX",    distanceMiles: 0.9, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "hou-he3", category: .health, name: "Cristo Clinic",                note: "Free primary care for uninsured",     phone: "+17136437878", address: "5540 Hirsch Rd, Houston, TX",        distanceMiles: 6.3, rating: 4.8, acceptsWalkIns: true),
        // Legal
        Resource(id: "hou-l1", category: .legal,   name: "Lone Star Legal Aid",         note: "Free civil & immigration legal help", phone: "+17132280732", address: "1415 Fannin St, Houston, TX",        distanceMiles: 0.7, rating: 4.6, acceptsWalkIns: true),
        Resource(id: "hou-l2", category: .legal,   name: "BakerRipley Immigration",     note: "Low-cost immigration legal services", phone: "+17139572424", address: "6500 Rookin St, Houston, TX",        distanceMiles: 4.8, rating: 4.7, acceptsWalkIns: false),
        Resource(id: "hou-l3", category: .legal,   name: "Catholic Charities Houston",  note: "Refugee & immigrant legal services",  phone: "+17135292901", address: "2900 Louisiana St, Houston, TX",     distanceMiles: 1.8, rating: 4.5, acceptsWalkIns: false),
        // Jobs
        Resource(id: "hou-j1", category: .jobs,    name: "Workforce Solutions Gulf Coast", note: "Free job placement & career services", phone: "+17133064100", address: "3555 Timmons Ln, Houston, TX",   distanceMiles: 4.1, rating: 4.2, acceptsWalkIns: true),
        Resource(id: "hou-j2", category: .jobs,    name: "IRC Houston",                  note: "Refugee employment & job training",   phone: "+17133265770", address: "2433 S Voss Rd, Houston, TX",       distanceMiles: 3.7, rating: 4.8, acceptsWalkIns: false),
        Resource(id: "hou-j3", category: .jobs,    name: "Houston Community College",    note: "Workforce certificates & ESL",        phone: "+17137181000", address: "3100 Main St, Houston, TX",         distanceMiles: 1.4, rating: 4.3, acceptsWalkIns: true),
        // Documents
        Resource(id: "hou-d1", category: .documents, name: "SSA — Midtown Houston",     note: "Social Security cards & benefits",    phone: "+18007721213", address: "1919 Smith St, Houston, TX",        distanceMiles: 0.6, rating: 3.5, acceptsWalkIns: false),
        Resource(id: "hou-d2", category: .documents, name: "TX DPS Driver License Office", note: "State ID & driver's license TX",    phone: "+15124245600", address: "6230 Westpark Dr, Houston, TX",     distanceMiles: 5.1, rating: 3.4, acceptsWalkIns: true),
        Resource(id: "hou-d3", category: .documents, name: "BakerRipley Document Help", note: "Document navigation & translation",   phone: "+17139572424", address: "6500 Rookin St, Houston, TX",       distanceMiles: 4.8, rating: 4.6, acceptsWalkIns: true),
    ]

    // MARK: Washington, DC

    static let dcResources: [Resource] = [
        // Housing
        Resource(id: "dc-h1", category: .housing, name: "DC Housing Authority",           note: "Public housing & Section 8 vouchers",  phone: "+12025358000", address: "1133 North Capitol St NE, DC",      distanceMiles: 1.4, rating: 3.7, acceptsWalkIns: true),
        Resource(id: "dc-h2", category: .housing, name: "Community of Hope",              note: "Affordable housing & family services",  phone: "+12024894693", address: "4713 Wisconsin Ave NW, DC",         distanceMiles: 3.8, rating: 4.6, acceptsWalkIns: false),
        Resource(id: "dc-h3", category: .housing, name: "Friendship Place",               note: "Housing for homeless & at-risk adults", phone: "+12025633070", address: "4713 Wisconsin Ave NW, DC",         distanceMiles: 3.8, rating: 4.5, acceptsWalkIns: true),
        // Food
        Resource(id: "dc-f1", category: .food,    name: "Capital Area Food Bank",         note: "Largest food bank in the DC metro",    phone: "+20233575500", address: "4900 Puerto Rico Ave NE, DC",       distanceMiles: 3.5, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "dc-f2", category: .food,    name: "SOME (So Others Might Eat)",     note: "Daily meals & emergency food",         phone: "+20223880820", address: "71 O St NW, Washington, DC",        distanceMiles: 0.9, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "dc-f3", category: .food,    name: "DC Central Kitchen",             note: "SNAP help & hot meals daily",          phone: "+20235450900", address: "425 2nd St NW, Washington, DC",     distanceMiles: 0.6, rating: 4.8, acceptsWalkIns: true),
        // Health
        Resource(id: "dc-he1", category: .health, name: "Unity Health Care",              note: "FQHC, sliding-scale, multilingual",    phone: "+20229412870", address: "3020 14th St NW, Washington, DC",   distanceMiles: 1.7, rating: 4.6, acceptsWalkIns: true),
        Resource(id: "dc-he2", category: .health, name: "Mary's Center",                  note: "Immigrant-focused community health",   phone: "+20225396100", address: "8712 Georgia Ave, Silver Spring, MD", distanceMiles: 6.1, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "dc-he3", category: .health, name: "DC Health Clinics",              note: "Free STI, TB & immunization services", phone: "+20244284994", address: "899 North Capitol St NE, DC",       distanceMiles: 1.1, rating: 4.0, acceptsWalkIns: true),
        // Legal
        Resource(id: "dc-l1", category: .legal,   name: "CAIR Coalition",                note: "Free immigration legal aid — DC area", phone: "+20281471600", address: "1612 K St NW, Washington, DC",      distanceMiles: 0.8, rating: 4.9, acceptsWalkIns: false),
        Resource(id: "dc-l2", category: .legal,   name: "AYUDA",                         note: "Immigrant legal & social services",    phone: "+20229610540", address: "6925 Willow St NW, Washington, DC",  distanceMiles: 4.6, rating: 4.8, acceptsWalkIns: false),
        Resource(id: "dc-l3", category: .legal,   name: "Catholic Charities DC",         note: "Immigration & refugee legal aid",      phone: "+20229222100", address: "924 G St NW, Washington, DC",       distanceMiles: 0.5, rating: 4.6, acceptsWalkIns: false),
        // Jobs
        Resource(id: "dc-j1", category: .jobs,    name: "DC Workforce Connection",       note: "Free job placement & career services", phone: "+20247435000", address: "4058 Minnesota Ave NE, DC",         distanceMiles: 3.2, rating: 4.1, acceptsWalkIns: true),
        Resource(id: "dc-j2", category: .jobs,    name: "IRC — Washington, DC",          note: "Refugee employment & resettlement",   phone: "+20214966500", address: "5225 Wisconsin Ave NW, DC",         distanceMiles: 3.9, rating: 4.7, acceptsWalkIns: false),
        Resource(id: "dc-j3", category: .jobs,    name: "Year Up DC",                    note: "Tech & professional job training",     phone: "+20271517300", address: "1875 Connecticut Ave NW, DC",       distanceMiles: 2.1, rating: 4.6, acceptsWalkIns: false),
        // Documents
        Resource(id: "dc-d1", category: .documents, name: "SSA — Downtown DC Office",   note: "Social Security cards & benefits",     phone: "+18007721213", address: "1st & D St NW, Washington, DC",     distanceMiles: 0.4, rating: 3.6, acceptsWalkIns: false),
        Resource(id: "dc-d2", category: .documents, name: "DC DMV — Georgetown",        note: "DC ID, driver's license & tabs",       phone: "+20262712000", address: "3222 M St NW, Washington, DC",       distanceMiles: 2.7, rating: 3.8, acceptsWalkIns: true),
        Resource(id: "dc-d3", category: .documents, name: "USCIS DC Field Office",      note: "Green card, citizenship, asylum",       phone: "+18003752444", address: "2675 Prosperity Ave, Fairfax, VA",  distanceMiles: 9.5, rating: 3.7, acceptsWalkIns: false),
    ]

    // MARK: Columbus, OH

    static let columbusResources: [Resource] = [
        // Housing
        Resource(id: "cmh-h1", category: .housing, name: "Columbus Metropolitan Housing Authority", note: "Public housing & Section 8",   phone: "+16142219981", address: "880 E 11th Ave, Columbus, OH",       distanceMiles: 1.6, rating: 3.8, acceptsWalkIns: true),
        Resource(id: "cmh-h2", category: .housing, name: "Community Housing Network",               note: "Affordable & supportive housing", phone: "+16148442000", address: "1421 Parkmoor Ave, Columbus, OH",   distanceMiles: 3.1, rating: 4.4, acceptsWalkIns: false),
        Resource(id: "cmh-h3", category: .housing, name: "Volunteers of America Ohio/Indiana",      note: "Emergency shelter & transitional housing", phone: "+16143397600", address: "1025 N High St, Columbus, OH", distanceMiles: 0.9, rating: 4.2, acceptsWalkIns: true),
        // Food
        Resource(id: "cmh-f1", category: .food,    name: "Mid-Ohio Food Collective",      note: "Largest food bank in central Ohio",    phone: "+16142726000", address: "3960 Brookham Dr, Grove City, OH",   distanceMiles: 7.2, rating: 4.8, acceptsWalkIns: true),
        Resource(id: "cmh-f2", category: .food,    name: "Somali Community Association",   note: "Halal food shelf — walk-in welcome",  phone: "+16147641044", address: "2800 Airport Dr, Columbus, OH",      distanceMiles: 4.3, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "cmh-f3", category: .food,    name: "YWCA Columbus Food Pantry",      note: "SNAP outreach & emergency food",      phone: "+16142243186", address: "65 S 4th St, Columbus, OH",          distanceMiles: 0.7, rating: 4.4, acceptsWalkIns: true),
        // Health
        Resource(id: "cmh-he1", category: .health, name: "Columbus Public Health",         note: "Free screenings, immunizations & WIC", phone: "+16142451100", address: "240 Parsons Ave, Columbus, OH",      distanceMiles: 0.9, rating: 4.1, acceptsWalkIns: true),
        Resource(id: "cmh-he2", category: .health, name: "OhioHealth Riverside Hospital",  note: "Emergency & specialty care",          phone: "+16143802000", address: "3535 Olentangy River Rd, Columbus",  distanceMiles: 3.4, rating: 4.3, acceptsWalkIns: true),
        Resource(id: "cmh-he3", category: .health, name: "Southeast Healthcare",           note: "Sliding-scale FQHC, multilingual",    phone: "+16143729090", address: "16 W Long St, Columbus, OH",         distanceMiles: 0.5, rating: 4.6, acceptsWalkIns: true),
        // Legal
        Resource(id: "cmh-l1", category: .legal,   name: "Community Legal Aid",           note: "Free civil & immigration legal aid",  phone: "+18882789441", address: "175 S 3rd St, Columbus, OH",         distanceMiles: 0.6, rating: 4.7, acceptsWalkIns: true),
        Resource(id: "cmh-l2", category: .legal,   name: "Community Refugee & Immigration Services (CRIS)", note: "Refugee legal services", phone: "+16142517700", address: "3624 Karl Rd, Columbus, OH",    distanceMiles: 5.1, rating: 4.8, acceptsWalkIns: false),
        Resource(id: "cmh-l3", category: .legal,   name: "Catholic Social Services Columbus", note: "Immigration & asylum legal aid",   phone: "+16142224648", address: "197 E Gay St, Columbus, OH",        distanceMiles: 0.4, rating: 4.6, acceptsWalkIns: false),
        // Jobs
        Resource(id: "cmh-j1", category: .jobs,    name: "OhioMeansJobs — Columbus",      note: "Free job search, training & placement", phone: "+16143418860", address: "1111 E Broad St, Columbus, OH",     distanceMiles: 1.3, rating: 4.1, acceptsWalkIns: true),
        Resource(id: "cmh-j2", category: .jobs,    name: "CRIS — Employment Services",     note: "Refugee job training & placement",    phone: "+16142517700", address: "3624 Karl Rd, Columbus, OH",        distanceMiles: 5.1, rating: 4.8, acceptsWalkIns: false),
        Resource(id: "cmh-j3", category: .jobs,    name: "Goodwill Columbus CareerLink",   note: "Job training for all skill levels",   phone: "+16142217000", address: "1331 Edgehill Rd, Columbus, OH",    distanceMiles: 3.8, rating: 4.2, acceptsWalkIns: true),
        // Documents
        Resource(id: "cmh-d1", category: .documents, name: "SSA — Columbus East Office",  note: "Social Security cards & benefits",    phone: "+18007721213", address: "200 N High St, Columbus, OH",       distanceMiles: 0.3, rating: 3.6, acceptsWalkIns: false),
        Resource(id: "cmh-d2", category: .documents, name: "Ohio BMV — Columbus Office",  note: "State ID & driver's license OH",      phone: "+16143524444", address: "1005 E Livingston Ave, Columbus, OH", distanceMiles: 1.7, rating: 3.5, acceptsWalkIns: true),
        Resource(id: "cmh-d3", category: .documents, name: "CRIS — Document Assistance",  note: "Document help & interpretation",       phone: "+16142517700", address: "3624 Karl Rd, Columbus, OH",       distanceMiles: 5.1, rating: 4.7, acceptsWalkIns: true),
    ]
}

// MARK: - Emergency Contact

struct EmergencyContact: Identifiable {
    let id = UUID()
    let emoji: String
    let titleKey: String
    let detail: String
    let color: ColorToken
    let bgColor: ColorToken
    let number: String
}

extension EmergencyContact {
    static let all: [EmergencyContact] = [
        EmergencyContact(emoji: "💬", titleKey: "Crisis Text Line",          detail: "Text HOME to 741741",  color: .green,  bgColor: .greenBg,  number: "741741"),
        EmergencyContact(emoji: "⚖️", titleKey: "Immigration Legal",         detail: "1-800-354-0365",        color: .blue,   bgColor: .blueBg,   number: "18003540365"),
        EmergencyContact(emoji: "🛡️", titleKey: "Domestic Violence Hotline", detail: "1-800-799-7233",        color: .purple, bgColor: .purpleBg, number: "18007997233"),
        EmergencyContact(emoji: "🏥", titleKey: "Nearest Hospital",          detail: "Grady Memorial ER",     color: .gold,   bgColor: .goldBg,   number: "+14046160600"),
        EmergencyContact(emoji: "🍎", titleKey: "Emergency Food",            detail: "1-877-423-4746",        color: .muted,  bgColor: .cream,    number: "18774234746"),
    ]
}
