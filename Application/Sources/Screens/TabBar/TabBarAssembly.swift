import Foundation
import DependencyInjection
import Characters

// MARK: - Tab bar assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей таб бара приложения.
final class TabBarAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(in container: DIContainer) {
        container
            .register(TabBarController.self) { container in
                MainActor.assumeIsolated {
                    let charactersController = container.resolve(CharactersCoordinator.self).start()
                    
                    let tabBarController = TabBarController()
                    tabBarController.viewControllers = [ charactersController ]
                    tabBarController.setupViewControllerTabItem(for: charactersController, item: .characters)
                    
                    return tabBarController
                }
            }
            .lifecycle(.singleton)
    }
}
