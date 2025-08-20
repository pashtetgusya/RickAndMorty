import UIKit

// MARK: - Rick and Morty character info assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// экрана информации о персонаже из вселенной `"Rick and Morty"`.
final class RnMCharacterInfoAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(container: DIContainer) {
        container
            .register(RnMCharacterInfoDependencies.self) { container in
                RnMCharacterInfoDependencies(di: container)
            }
        
        container
            .register(RnMCharacterInfoViewModel.self) { (container: DIContainer, characterId: Int) in
                MainActor.assumeIsolated {
                    let dependencies = container.resolve(RnMCharacterInfoDependencies.self)
                    let viewModel = RnMCharacterInfoViewModel(characterId: characterId, di: dependencies)
                    
                    return viewModel
                }
            }
        
        container
            .register(RnMCharacterInfoViewController.self) { (container: DIContainer, characterId: Int) in
                MainActor.assumeIsolated {
                    let viewModel = container.resolve(RnMCharacterInfoViewModel.self, args: characterId)
                    let viewController = RnMCharacterInfoViewController(viewModel: viewModel)
                    
                    return viewController
                }
            }
    }
}
