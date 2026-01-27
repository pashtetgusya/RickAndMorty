import Foundation

// MARK: - Network connection type

/// Энам, описывающий перечень возможных типов подключения к сети.
public enum NetworkConnectionType: Sendable, Equatable {
    
    // MARK: Cases
    
    case cellular
    case wifi
}
