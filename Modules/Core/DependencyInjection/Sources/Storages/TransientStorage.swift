import Foundation

// MARK: - Transient dependency storage

/// Класс, реализующий интерфейс хранилища зависимости,
/// время жизни которой равно времени жизни использующих его компонентов.
///
/// Данное хранилище не хранит в себе экземпляр зависимости и всегда возвращает `nil`.
final class TransientStorage: DIStorage {
    
    // MARK: Properties
    
    var instance: Any? { nil }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() { }
}
