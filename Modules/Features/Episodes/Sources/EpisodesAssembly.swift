import Foundation
import UIComponents
import DependencyInjection

// MARK: - Episodes assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// модуля эпизодов из вселенной `"Rick and Morty"`.
public final class EpisodesAssembly: DIAssembly {
    
    // MARK: Initialization
    
    public init() { }
    
    // MARK: DI assembly protocol implementation
    
    public func assemble(in container: DIContainer) {
        let assemblies: [DIAssembly] = [EpisodeListAssembly()]
        assemblies.forEach { $0.assemble(in: container) }
        
        container
            .register(EpisodesCoordinator.self) { @MainActor (
                container,
                args: BaseNavigationController
            ) -> EpisodesCoordinator in
                EpisodesCoordinator(di: container, navController: args)
            }
            .implements(EpisodeListCoordinator.self)
            .lifecycle(.weak)
    }
}
