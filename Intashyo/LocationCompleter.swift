// LocationCompleter.swift — MKLocalSearchCompleter wrapper

import MapKit
import Combine

final class LocationCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    private let completer = MKLocalSearchCompleter()
    @Published var suggestions: [String] = []

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address]
    }

    func update(query: String) {
        guard query.count >= 2 else { suggestions = []; return }
        completer.queryFragment = query
    }

    func clear() { suggestions = [] }

    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results.prefix(5).map { r -> String in
            r.subtitle.isEmpty ? r.title : "\(r.title), \(r.subtitle)"
        }
        DispatchQueue.main.async { self.suggestions = Array(results) }
    }

    nonisolated func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        DispatchQueue.main.async { self.suggestions = [] }
    }
}
