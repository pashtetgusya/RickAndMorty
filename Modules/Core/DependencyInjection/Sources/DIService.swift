import Foundation
import ToolBox

// MARK: - Dependency injection service

/// Класс, описывающий зависимость для регистрации в `DI`-контейнере.
public final class DIService {
    
    // MARK: Properties
    
    /// Время жизни зависимости в контейнере
    /// (по умолчанию испольузется `transient`).
    @Atomic private(set) var lifecycle: DILifeCycle = .transient
    /// Перечень интерфейсов которые реализует зависимость.
    @Atomic private(set) var conformingProtocolList: Set<String> = []
    /// Замыкание, используемое для создания экземпляра зависимости.
    public let instanceFactory: Any
    /// Хранилище с экземпляром зависимости.
    @Atomic private(set) var instanseStorage: DIStorage?
    /// Контейнер в котором зарегистрирована зависимость.
    private weak var ownerContainer: DIContainer?
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - factory: замыкание для создания экземпляра зависимости.
    ///   - container: контейнер в котором регистрируется зависимость.
    public init(
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
    @discardableResult public func lifecycle(_ newLifecycle: DILifeCycle) -> DIService {
        lifecycle = newLifecycle
        
        return self
    }
    
    /// Регистрирует дополнительные интерфейсы, которые реализует зависимость.
    /// - Parameter typeList: перечень интерфейсов которые реализует зависимость.
    /// - Returns: экземпляр зависимости (для построения цепочки вызовов).
    @discardableResult public func implements<P>(_ typeList: P.Type...) -> DIService {
        typeList.forEach { conformingProtocolList.insert(String(describing: $0)) }
        ownerContainer?.updateRegistration(for: self)
        
        return self
    }
    
    /// Выполняет сохранение экземпляра зависимости в хранилище.
    /// - Parameter instance: экземпляр зависимости.
    public func saveInstance(_ instance: Any) {
        instanseStorage = switch lifecycle {
        case .singleton: SingletonStorage(instance)
        case .transient: TransientStorage()
        case .weak: WeakStorage(instance)
        }
    }
}
