import Foundation
import DependencyInjection

// MARK: - Application dependency injection container

/// Класс, реализующий интерфейс `DI`-контейнера для управления зависимостями приложения.
final class AppDIContainer {
    
    /// Мьютекс для обеспечения потокобезопасности при работе с контейнером зависимостей.
    private let lock = NSRecursiveLock()
    /// Контейнер для регистации / получения зависимостей.
    nonisolated(unsafe) private var services: [String: DIService] = [:]
    /// Контейнер для регистации / получения синглтон зависимостей.
    nonisolated(unsafe) private var singletonServices: [String: Any] = [:]
}

// MARK: - DI container protocol implementation

extension AppDIContainer: DIContainer {
    
    @discardableResult func register<Service>(
        _ type: Service.Type,
        _ resolver: @escaping (DIContainer) -> Service
    ) -> DIService {
        _register(type, resolver)
    }
    
    @discardableResult func register<Service, Arguments>(
        _ type: Service.Type,
        _ resolver: @escaping (DIContainer, Arguments) -> Service
    ) -> DIService {
        _register(type, resolver)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        defer { lock.unlock() }
        lock.lock()
        
        let key = String(describing: T.self)
        
        guard
            let service = services[key]
        else { fatalError("\(key) is not registered in container") }
        
        switch service.lifecycle {
        case .singleton:
            if let instance = singletonServices[key] as? T { return instance }
            else {
                guard
                    let factory = service.instanceFactory as? (DIContainer) -> T
                else { fatalError("\(key) is not registered in container") }
                
                let instance = factory(self)
                singletonServices[key] = instance
                service.conformingProtocolList.forEach { singletonServices[$0] = instance }
                
                return instance
            }
        case .transient:
            guard
                let factory = service.instanceFactory as? (DIContainer) -> T
            else { fatalError("\(key) is not registered in container") }
            
            let instance = factory(self)
            
            return instance
        }
    }
    
    func resolve<T, Arguments>(_ type: T.Type, args: Arguments) -> T {
        defer { lock.unlock() }
        lock.lock()
        
        let key = String(describing: T.self)
        
        guard
            let service = services[key]
        else { fatalError("\(key) is not registered in container") }
        
        switch service.lifecycle {
        case .singleton:
            if let instance = singletonServices[key] as? T { return instance }
            else {
                guard
                    let factory = service.instanceFactory as? ((DIContainer, (Arguments))) -> T
                else { fatalError("\(key) is not registered in container") }
                
                let instance = factory((self, args))
                singletonServices[key] = instance
                service.conformingProtocolList.forEach { singletonServices[$0] = instance }
                
                return instance
            }
        case .transient:
            guard
                let factory = service.instanceFactory as? ((DIContainer, (Arguments))) -> T
            else { fatalError("\(key) is not registered in container") }
            
            let instance = factory((self, args))
            
            return instance
        }
    }
    
    func updateRegistration(for service: DIService) {
        service.conformingProtocolList.forEach {
            services[$0] = service
        }
    }
}

// MARK: - Registration support functions

private extension AppDIContainer {
    
    /// Выполняет регистрацию зависимости в контейнере.
    /// - Parameters:
    ///   - type: тип регистрируемой зависимости.
    ///   - resolver: замыкание для создания экземпляра зависимости.
    /// - Returns: экземпляр зависимости (для построения цепочки вызовов).
    func _register<Service, Arguments>(
        _ type: Service.Type,
        _ resolver: @escaping (Arguments) -> Service
    ) -> DIService {
        defer { lock.unlock() }
        lock.lock()
        
        let service = DIService(container: self, factory: resolver)
        let primaryKey = String(describing: Service.self)
        services[primaryKey] = service
        
        return service
    }
}
