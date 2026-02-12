import Foundation

// MARK: - Singleton dependensy storage

/// Класс, реализующий интерфейс хранилища зависимости,
/// время жизни которой равно времени жизни приложения.
final class SingletonStorage: DIStorage {
    
    // MARK: Properties
    
    private let _instance: Any?
    var instance: Any? { _instance }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter instance: хранимая зависимость.
    init(_ instance: Any?) {
        self._instance = instance
    }
}
