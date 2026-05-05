// Language.swift — In-app language management + all localized strings

import Foundation

// MARK: - Language Enum

enum Language: String, CaseIterable, Identifiable {
    case kinyarwanda
    case french
    case swahili
    case english

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .kinyarwanda: return "🇷🇼"
        case .french:      return "🇫🇷"
        case .swahili:     return "🌍"
        case .english:     return "🇺🇸"
        }
    }

    var code: String {
        switch self {
        case .kinyarwanda: return "RW"
        case .french:      return "FR"
        case .swahili:     return "SW"
        case .english:     return "EN"
        }
    }

    var nativeName: String {
        switch self {
        case .kinyarwanda: return "Kinyarwanda"
        case .french:      return "Français"
        case .swahili:     return "Kiswahili"
        case .english:     return "English"
        }
    }

    var nativeGreeting: String {
        switch self {
        case .kinyarwanda: return "Murakaza neza"
        case .french:      return "Bienvenue"
        case .swahili:     return "Karibu"
        case .english:     return "Welcome"
        }
    }
}

// MARK: - Localized Strings

struct L {
    let lang: Language

    // Language Select
    var chooseLanguage:   String { s("Hitamo ururimi rwawe",    "Choisissez votre langue",       "Chagua lugha yako",      "Choose your language") }
    var guideTagline:     String { s("Inzira yawe muri Amerika","Votre guide aux États-Unis",    "Mwongozo wako Amerika",  "Your guide to life in the US") }
    var moreLanguages:    String { s("Izindi ndimi zizaza vuba","D'autres langues bientôt",      "Lugha zaidi zinakuja",   "More languages coming soon") }

    // Onboarding
    var namePrompt:       String { s("Witwa nde?",              "Comment vous appelez-vous ?",   "Jina lako ni nani?",     "What is your name?") }
    var namePromptSub:    String { s("Tuzakakoresha kugufasha", "Nous l'utiliserons pour vous aider","Tutaitumia kukusaidia","We'll use it to personalize your experience") }
    var namePlaceholder:  String { s("Injiza izina ryawe...",   "Entrez votre prénom...",        "Ingiza jina lako...",    "Enter your first name...") }
    var onboardQ1:        String { s("Watuye igihe kingana iki muri Amerika?", "Depuis combien de temps êtes-vous aux États-Unis ?", "Umekuwa Amerika kwa muda gani?", "How long have you been in the US?") }
    var onboardA1_0:      String { s("Naje vuba (0–3 amezi)",   "Je viens d'arriver (0–3 mois)", "Nimefika hivi karibuni (0–3 miezi)", "Just arrived (0–3 months)") }
    var onboardA1_1:      String { s("Amezi 3–12",              "3–12 mois",                     "Miezi 3–12",             "3–12 months") }
    var onboardA1_2:      String { s("Imyaka irenga 1",         "Plus d'un an",                  "Zaidi ya mwaka 1",       "Over a year") }
    var onboardQ2:        String { s("Uri mu mujyi uwo ari wo?","Dans quelle ville êtes-vous ?", "Uko katika mji gani?",   "What city are you in?") }
    var onboardPlaceholder: String { s("Urugero: Atlanta, GA",  "Ex : Atlanta, GA",              "Mfano: Atlanta, GA",     "e.g. Atlanta, GA or 30303") }
    var getStarted:       String { s("Tangira →",               "Commencer →",                   "Anza →",                 "Get started →") }
    var skipNow:          String { s("Simbuka ubu →",           "Passer pour l'instant →",       "Ruka kwa sasa →",        "Skip for now →") }
    var onboardDone:      String { s("Turaho!",                 "Nous sommes prêts !",            "Tuko tayari!",           "You're all set!") }

    // Home
    var greeting:         String { s("Muraho",                  "Bonjour",                       "Habari",                 "Hello") }
    var subGreeting:      String { s("Murakaza neza",           "Bienvenue",                     "Karibu",                 "Welcome") }
    var tagline:          String { s("Inzira yawe muri Amerika","Votre guide aux États-Unis",    "Mwongozo wako Amerika",  "Your guide to life in the US") }
    var quickAccess:      String { s("IBIKENEWE BYIHUSE",       "ACCÈS RAPIDE",                  "UFIKIAJI WA HARAKA",     "QUICK ACCESS") }
    var checklist:        String { s("Urutonde rw'ibikorwa bishya","Liste des premières étapes", "Orodha ya mwanzo",       "New arrival checklist") }
    var checklistSub:     String { s("3 kuri 8 birakozwe",      "3 sur 8 étapes complétées",     "Hatua 3 kati ya 8 zimekamilika","3 of 8 steps complete") }
    var eslAlert:         String { s("Amasomo y'Icyongereza afunguye","Cours d'anglais gratuits près de chez vous","Madarasa ya Kiingereza bure karibu nawe","Free ESL classes near you") }
    var eslSub:           String { s("Itangira ku Cyumweru · Ahantu 3","Commence lundi · 3 lieux disponibles","Inaanza Jumatatu · Maeneo 3","Starts Monday · 3 locations open") }
    var askAnything:      String { s("Baza ikibazo cyose",      "Posez une question",            "Uliza swali lolote",     "Ask me anything") }
    var chatSub:          String { s("Igisubizo mu Kinyarwanda","Réponses en français",          "Majibu kwa Kiswahili",   "Answers in English") }

    // Category names
    var catHousing:       String { s("Inzu",                    "Logement",                      "Makazi",                 "Housing") }
    var catFood:          String { s("Ibiribwa",                "Alimentation",                  "Chakula",                "Food & SNAP") }
    var catHealth:        String { s("Ubuvuzi",                 "Santé",                         "Afya",                   "Healthcare") }
    var catLegal:         String { s("Amategeko",               "Aide juridique",                "Msaada wa kisheria",     "Legal Aid") }
    var catJobs:          String { s("Akazi",                   "Emploi",                        "Kazi",                   "Jobs") }
    var catDocs:          String { s("Impapuro",                "Documents",                     "Nyaraka",                "Documents") }

    // Resources
    var resources:        String { s("Ibikorwa",                "Ressources",                    "Rasilimali",             "Resources") }
    var findWhat:         String { s("Shakisha ibyo ukeneye",   "Trouvez ce dont vous avez besoin","Tafuta unachohitaji",  "Find what you need") }
    var searchPlaceholder: String { s("Shakisha...",            "Rechercher...",                 "Tafuta...",              "Search resources...") }
    var resourcesAvailable: String { s("ahantu ahari",         "ressources disponibles",        "rasilimali zinapatikana","resources available") }
    var nearYou:          String { s("Hafi yawe",              "Près de chez vous",             "Karibu nawe",            "Near you") }

    // Resource Detail
    var away:             String { s("uvuyeho",                 "de distance",                   "umbali",                 "away") }
    var call:             String { s("Hamagara",                "Appeler",                       "Piga simu",              "Call") }
    var directions:       String { s("Inzira",                  "Itinéraire",                    "Maelekezo",              "Directions") }
    var save:             String { s("Bika",                    "Enregistrer",                   "Hifadhi",                "Save") }
    var askAiAbout:       String { s("Baza ubufasha bw'AI",     "Demander à l'assistant IA",     "Uliza msaidizi wa AI",   "Ask AI about") }

    // AI Chat
    var aiChat:           String { s("Ubufasha",                "Assistant",                     "Msaidizi",               "AI Chat") }
    var online:           String { s("Hari hano",               "En ligne",                      "Mtandaoni",              "Online") }
    var trySuggestions:   String { s("GERAGEZA KUBAZA:",        "ESSAYEZ DE DEMANDER :",         "JARIBU KUULIZA:",        "TRY ASKING:") }
    var typePlaceholder:  String { s("Andika ibibazo...",       "Écrivez votre question...",     "Andika swali lako...",   "Type your question...") }
    var hello:            String { s("Muraho!",                 "Bonjour !",                     "Habari!",                "Hello!") }
    var helpPrompt:       String { s("Nakugira iki uyu munsi?", "Comment puis-je vous aider ?",  "Naweza kukusaidia vipi leo?","How can I help you today?") }

    // Suggested prompts: [question, hint]
    var suggested: [(String, String)] {
        switch lang {
        case .kinyarwanda: return [
            ("Nakura SSN gute?",        "Urupapuro rw'umwirondoro"),
            ("Ndashaka inzu",           "Ubufasha bw'aho gutura"),
            ("Ni gute mbona muganga?",  "Ubufasha bw'ubuvuzi")
        ]
        case .french: return [
            ("Comment obtenir mon numéro de sécurité sociale ?", "Documents"),
            ("J'ai besoin d'un logement",                        "Aide au logement"),
            ("Comment voir un médecin ?",                        "Santé")
        ]
        case .swahili: return [
            ("Nitapata nambari ya SSN vipi?", "Nyaraka"),
            ("Ninahitaji makazi",             "Msaada wa makazi"),
            ("Ninawezaje kuona daktari?",     "Afya")
        ]
        case .english: return [
            ("How do I get my Social Security card?", "Documents"),
            ("I need housing help",                   "Housing"),
            ("How do I see a doctor?",                "Healthcare")
        ]
        }
    }

    // Emergency
    var emergency:         String { s("Ihutirwa",               "Urgence",                       "Dharura",                "Emergency") }
    var quickContacts:     String { s("Ihutirwa · Imibare ya vuba","Urgence · Contacts rapides", "Dharura · Mawasiliano ya haraka","Quick contacts") }
    var emergencyServices: String { s("Polisi · Inkongi · Umuvuzi","Police · Pompiers · Médecins","Polisi · Zima moto · Daktari","Police · Fire · Medical") }
    var callPolice:        String { s("Hamagara 911",           "Appeler le 911",                "Piga simu 911",          "Call 911") }
    var textPolice:        String { s("Ohereza 911",            "SMS au 911",                    "Tuma ujumbe 911",        "Text 911") }
    var otherContacts:     String { s("IMIBARE ITERA INKUNGA",  "AUTRES CONTACTS D'URGENCE",     "MAWASILIANO MENGINE YA DHARURA","OTHER EMERGENCY CONTACTS") }

    // Language Modal
    var changeLang:        String { s("Hindura ururimi",        "Changer de langue",             "Badilisha lugha",        "Change language") }

    // Tab Bar
    var tabHome:           String { s("Ahabanza",               "Accueil",                       "Nyumbani",               "Home") }
    var tabResources:      String { s("Ibikorwa",               "Ressources",                    "Rasilimali",             "Resources") }
    var tabChat:           String { s("Ubufasha",               "Assistant",                     "Msaidizi",               "AI Chat") }
    var tabEmergency:      String { s("Ihutirwa",               "Urgence",                       "Dharura",                "Emergency") }
    var tabProfile:        String { s("Umwirondoro",            "Profil",                        "Wasifu",                 "Profile") }

    // Error states
    var errorOffline:      String { s("Ntamurandasi. Gerageza nanone.","Pas de connexion. Réessayez.","Hakuna mtandao. Jaribu tena.","No connection. Please try again.") }
    var errorGeneric:      String { s("Ikibazo gihari. Gerageza nanone.","Une erreur s'est produite. Réessayez.","Hitilafu imetokea. Jaribu tena.","Something went wrong. Try again.") }
    var errorRateLimit:    String { s("Urenze umupaka. Gerageza nyuma.","Limite atteinte. Réessayez plus tard.","Umefika kikomo. Jaribu baadaye.","Limit reached. Try again later.") }

    // AI system prompt language name
    var aiLanguageName: String {
        switch lang {
        case .kinyarwanda: return "Kinyarwanda"
        case .french:      return "French"
        case .swahili:     return "Swahili"
        case .english:     return "English"
        }
    }

    // MARK: - Helper
    private func s(_ rw: String, _ fr: String, _ sw: String, _ en: String) -> String {
        switch lang {
        case .kinyarwanda: return rw
        case .french:      return fr
        case .swahili:     return sw
        case .english:     return en
        }
    }
}
