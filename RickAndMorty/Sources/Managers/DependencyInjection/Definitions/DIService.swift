import Foundation

// MARK: - Dependency injection service

/// Класс, описывающий зависимость для регистрации в DI-контейнере.
final class DIService {
    
    // MARK: Properties
    
    /// Время жизни зависимости в контейнере
    /// (по умолчанию испольузется `transient`).
    private(set) var lifecycle: DILifecycle = .transient
    /// Перечень интерфейсов которые реализует зависимость.
    private(set) var conformingProtocolList: Set<String> = []
    /// Замыкани, используемое для создания экземпляра зависимости.
    let instanceFactory: Any
    /// Контейнер в котором зарегистрирована зависимость.
    private weak var ownerContainer: DIContainer?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - factory: замыкание для создания экземпляра зависимости.
    ///   - container: контейнер в котором регистрируется зависимость.
    init(
        container: DIContainer,
        factory: Any
    ) {
        self.ownerContainer = container
        self.instanceFactory = factory
    }
    
    // MARK: Configuration functions
    
    /// Устанавливает время жизни зависимости.
    /// - Parameter newLifecycle: новое значение времени жизни.
    /// - Returns: экземпляр зависимости (для построения цепочки вызовов).
    @discardableResult func lifecycle(_ newLifecycle: DILifecycle) -> DIService {
        lifecycle = newLifecycle
        
        return self
    }
    
    /// Регистрирует дополнительные интерфейсы, которые реализует зависимость.
    /// - Parameter typeList: перечень интерфейсов которые реализует зависимость.
    /// - Returns: экземпляр зависимости (для построения цепочки вызовов).
    @discardableResult func implements<P>(_ typeList: P.Type...) -> DIService {
        typeList.forEach { conformingProtocolList.insert(String(describing: $0)) }
        ownerContainer?.updateRegistration(for: self)
        
        return self
    }
}
