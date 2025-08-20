import Foundation

// MARK: - Dependency injection assembly protocol

/// Интерфейс `DI`-компонента для модульной регистрации зависимостей.
protocol DIAssembly: Sendable {
    
    /// Выполняет регистрацию зависимостей модуля в указанном контейнере.
    /// - Parameter container: `DI`-контейнер в котором регистрируются зависимости.
    func assemble(container: DIContainer)
}
