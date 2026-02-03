import UIKit
import DependencyInjection

// MARK: - Coordinator protocol

/// Интерфейс координатора, управляющего потоком навигации в приложении.
@MainActor public protocol Coordinator: AnyObject, Sendable {
    
    // MARK: Properties
    
    /// Контейнер с зависимостями.
    var diContainer: DIContainer { get }
    /// Список дочерних координаторов.
    var childCoordinators: [Coordinator] { get set }
    /// Навигационный контроллер координатора.
    var navController: UINavigationController { get }
    /// Замыкание, которе будет вызвано после завершения работы координатора.
    var didFinish: ((Coordinator) -> Void)? { get set }
    
    // MARK: Functions
    
    /// Выполняет запуск потока координатора.
    func start()
    /// Выполняет сброс навигационного стека к корневому `UIViewController`.
    /// - Parameter animated: флаг необходимости выполнения анимации.
    /// - Returns: экземпрял координатора (для построения цепочки вызовов).
    @discardableResult func resetToRoot(animated: Bool) -> Self
    /// Добавляет дочерний координатор.
    func addChild(_ coordinator: Coordinator)
    /// Удаляет дочерний координатор.
    func removeChild(_ coordinator: Coordinator)
}

// MARK: - Coordinator protocol base implementation

public extension Coordinator {
    
    func resetToRoot(animated: Bool) -> Self {
        navController.popToRootViewController(animated: animated)
        
        return self
    }
    
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
