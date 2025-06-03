import Foundation

// MARK: - Application dependency injection container

/// Класс, реализующий интерфейс контейнера для управления зависимостями приложения.
final class AppDIContainer: DIContainer {
    
    // MARK: Properties
    
    /// Мьютекс для обеспечения потокобезопасности при работе с контейнером зависимостей.
    private let lock = NSRecursiveLock()
    /// Контейнер для регистации / получения зависимостей.
    nonisolated(unsafe) private var services: [String: Any] = [:]
    
    // MARK: Functions
    
    func register<T>(_ type: T.Type, resolver: @escaping (DIContainer) -> T) {
        defer { lock.unlock() }
        lock.lock()
        
        services[String(describing: T.self)] = resolver(self)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        defer { lock.unlock() }
        lock.lock()
        
        guard
            let service = services[String(describing: type)] as? T
        else { fatalError("service \(T.self) is not registered in container") }
        
        return service
    }
}
