import Foundation

// MARK: - Rick and Morty characters assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// модуля персонажей из вселенной `"Rick and Morty"`.
final class RnMCharactersAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(container: DIContainer) {
        let assemblies: [DIAssembly] = [
            RnMCharacterListAssembly(),
            RnMCharacterInfoAssembly(),
            RnMCharacterFilterAssembly(),
        ]
        assemblies.forEach { $0.assemble(container: container) }
        
        container
            .register(RnMCharactersCoordinator.self) { container in
                MainActor.assumeIsolated {
                    RnMCharactersCoordinator(di: container)
                }
            }
            .implements(RnMCharacterListCoordinator.self)
            .lifecycle(.singleton)
    }
}
