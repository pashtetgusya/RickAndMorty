import Foundation
import ToolBox

// MARK: - Dependency injection container

/// Класс, реализующий `DI`-контейнер для управления зависимостями.
public final class DIContainer: @unchecked Sendable {
    
    // MARK: Properties
    
    /// Словарь с контейнерами для регистрации / получения зависимостей.
    @Atomic private var services: [String: DIService] = [:]
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    public init() { }
}

// MARK: - Dependency register / resolve functions

public extension DIContainer {
    
    /// Выполняет регистрацию зависимости в контейнере.
    /// - Parameters:
    ///   - type: тип регистрируемой зависимости.
    ///   - resolver: замыкание для создания экземпляра зависимости.
    /// - Returns: экземпляр зависимости (для построения цепочки вызовов).
    @discardableResult func register<Service>(
        _ type: Service.Type,
        _ resolver: @escaping (DIContainer) -> Service
    ) -> DIService {
        _register(type, resolver)
    }
    
    /// Выполняет регистрацию зависимости в контейнере.
    ///
    /// Позволяет передавать дополнительные параметры для зависимостей.
    /// - Parameters:
    ///   - type: тип регистрируемой зависимости.
    ///   - resolver: замыкание для создания экземпляра зависимости.
    /// - Returns: экземпляр зависимости (для построения цепочки вызовов).
    @discardableResult func register<Service, Arguments>(
        _ type: Service.Type,
        _ resolver: @escaping (DIContainer, Arguments) -> Service
    ) -> DIService {
        _register(type, resolver)
    }
    
    /// Выполняет получение экземпляра зарегистрированной в контейнере зависимости.
    ///
    /// Если зависимость не зарегистрирована или не может быть приведена к указанному типу
    /// выполняет вызов `fatalError` с соответствующим сообщением.
    /// - Parameters:
    ///   - type: тип запрашиваемой зависимости.
    ///   - args: дополнительные параметры зависимости.
    /// - Returns: экземпляр запрашиваемой зависимости.
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: T.self)
        
        guard
            let service = services[key]
        else { fatalError("\(key) is not registered in container") }
        
        if let instance = service.instanseStorage?.instance as? T {
            return instance
        }
        else {
            guard
                let factory = service.instanceFactory as? (DIContainer) -> T
            else { fatalError("\(key) is not registered in container") }
            
            let instance = factory(self)
            service.saveInstance(instance)
            
            return instance
        }
    }
    
    /// Выполняет получение экземпляра зарегистрированной в контейнере зависимости.
    ///
    /// Позволяет передавать дополнительные параметры для создания зависимостей.
    ///
    /// Если зависимость не зарегистрирована или не может быть приведена к указанному типу
    /// выполняет вызов `fatalError` с соответствующим сообщением.
    /// - Parameters:
    ///   - type: тип запрашиваемой зависимости.
    ///   - args: дополнительные параметры зависимости.
    /// - Returns: экземпляр запрашиваемой зависимости.
    func resolve<T, Arguments>(_ type: T.Type, args: Arguments) -> T {
        let key = String(describing: T.self)
        
        guard
            let service = services[key]
        else { fatalError("\(key) is not registered in container") }
        
        if let instance = service.instanseStorage?.instance as? T {
            return instance
        }
        else {
            guard
                let factory = service.instanceFactory as? ((DIContainer, (Arguments))) -> T
            else { fatalError("\(key) is not registered in container") }
            
            let instance = factory((self, args))
            service.saveInstance(instance)
            
            return instance
        }
    }
    
    /// Выполняет обновление регистрации зависимости в контейнере.
    /// - Parameter service: зависимость для которой необходимо обновить регистрацию.
    func updateRegistration(for service: DIService) {
        service.conformingProtocolList.forEach {
            services[$0] = service
        }
    }
}

// MARK: - Register support functions

private extension DIContainer {
    
    /// Выполняет регистрацию зависимости в контейнере.
    /// - Parameters:
    ///   - type: тип регистрируемой зависимости.
    ///   - resolver: замыкание для создания экземпляра зависимости.
    /// - Returns: экземпляр зависимости (для построения цепочки вызовов).
    func _register<Service, Arguments>(
        _ type: Service.Type,
        _ resolver: @escaping (Arguments) -> Service
    ) -> DIService {
        let service = DIService(container: self, factory: resolver)
        let primaryKey = String(describing: Service.self)
        services[primaryKey] = service
        
        return service
    }
}
