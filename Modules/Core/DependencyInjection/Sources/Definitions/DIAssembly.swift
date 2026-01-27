import Foundation

// MARK: - Dependency injection assembly protocol

/// Интерфейс `DI`-компонента для модульной регистрации зависимостей.
public protocol DIAssembly: Sendable {
    
    /// Выполняет регистрацию зависимостей модуля в указанном контейнере.
    /// - Parameter container: `DI`-контейнер в котором регистрируются зависимости.
    func assemble(in container: DIContainer)
}
