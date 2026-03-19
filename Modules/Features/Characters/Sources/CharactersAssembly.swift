import Foundation
import UIComponents
import DependencyInjection

// MARK: - Characters assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// модуля персонажей из вселенной `"Rick and Morty"`.
public final class CharactersAssembly: DIAssembly {
    
    // MARK: Initialization
    
    public init() { }
    
    // MARK: DI assembly protocol implementation
    
    public func assemble(in container: DIContainer) {
        let assemblies: [DIAssembly] = [
            CharacterListAssembly(),
            CharacterInfoAssembly(),
            CharacterFilterAssembly()
        ]
        assemblies.forEach { $0.assemble(in: container) }
        
        container
            .register(CharactersCoordinator.self) { @MainActor (
                container,
                args: BaseNavigationController
            ) -> CharactersCoordinator in
                CharactersCoordinator(di: container, navController: args)
            }
            .implements(CharacterListCoordinator.self)
            .lifecycle(.weak)
    }
}
