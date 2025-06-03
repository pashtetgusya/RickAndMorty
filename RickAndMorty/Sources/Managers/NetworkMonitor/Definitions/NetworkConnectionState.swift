import Foundation

// MARK: - Network connection state

/// Перечень статусов подключения к сети.
enum NetworkConnectionState: Equatable {
    
    // MARK: Cases
    
    /// Подключение к сети доступно.
    case reachable(withType: NetworkConnectionType)
    /// Подклчюение к сети недоступно.
    case unreachable
    
    // MARK: Equatable protocol implementation
    
    static func == (
        lhs: NetworkConnectionState,
        rhs: NetworkConnectionState
    ) -> Bool {
        switch (lhs, rhs) {
        case (.reachable, .reachable): true
        case (.unreachable, .unreachable): true
        
        default: false
        }
    }
}
