import Foundation

// MARK: - Dependency injection container protocol

/// Интерфейс контейнер для управления зависимостями.
protocol DIContainer: Sendable {
    
    // MARK: Functions
    
    /// Регистрирует зависимость в контейнер.
    ///
    /// - Parameters:
    ///   - type: тип регистрируемой зависимости.
    ///   - resolver: замыкание для создания экземпляра зависимости.
    func register<T>(_ type: T.Type, resolver: @escaping (DIContainer) -> T)
    /// Возвращает экземпляр зарегистрированной зависимости.
    ///
    /// Если зависимость не зарегистрирована или не может быть приведена к указанному типу
    /// вызовется `fatalError` с соответствующим сообщением.
    /// - Parameter type: тип запрашиваемой зависимости.
    /// - Returns: экземпляр запрашиваемой зависимости.
    func resolve<T>(_ type: T.Type) -> T
}
