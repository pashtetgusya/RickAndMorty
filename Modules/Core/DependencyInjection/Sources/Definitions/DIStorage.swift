import Foundation

// MARK: - Dependency injection storage

/// Интерфейс хранилища экземпляра зависимости.
protocol DIStorage: AnyObject {
    
    // MARK: Properties
    
    /// Экземпляр хранимой зависимости.
    var instance: Any? { get }
}
