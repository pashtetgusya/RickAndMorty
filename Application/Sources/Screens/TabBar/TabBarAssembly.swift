import Foundation
import DependencyInjection

// MARK: - Tab bar assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей таб бара приложения.
final class TabBarAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(in container: DIContainer) {
        container
            .register(TabBarController.self) { _ in
                TabBarController()
            }
            .lifecycle(.singleton)
    }
}
