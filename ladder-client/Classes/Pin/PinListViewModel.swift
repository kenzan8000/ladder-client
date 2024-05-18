import Foundation

// MARK: - PinListViewModel

final class PinListViewModel: ObservableObject {
    // MARK: - Public properties
    
    @Published var pins: [Pin] = []
}
