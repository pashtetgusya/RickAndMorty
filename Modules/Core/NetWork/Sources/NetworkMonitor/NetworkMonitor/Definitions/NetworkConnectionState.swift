import Foundation

// MARK: - Network connection state

/// Энам, описывающий перечень возможных статусов подключения к сети.
public enum NetworkConnectionState: Sendable, Equatable {
    
    // MARK: Cases
    
    /// Подключение к сети доступно.
    case reachable(withType: NetworkConnectionType)
    /// Подклчюение к сети недоступно.
    case unreachable
    
    // MARK: Equatable protocol implementation
    
    public static func == (
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
