import UIKit
import DependencyInjection

// MARK: - Character info assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// экрана информации о персонаже из вселенной `"Rick and Morty"`.
final class CharacterInfoAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(in container: DIContainer) {
        container
            .register(CharacterInfoViewModelDependencies.self) { container in
                CharacterInfoViewModelDependencies(di: container)
            }
        
        container
            .register(CharacterInfoViewModel.self) { (container: DIContainer, characterId: Int) in
                MainActor.assumeIsolated {
                    let dependencies = container.resolve(CharacterInfoViewModelDependencies.self)
                    let viewModel = CharacterInfoViewModel(characterId: characterId, di: dependencies)
                    
                    return viewModel
                }
            }
        
        container
            .register(CharacterInfoViewController.self) { (container: DIContainer, characterId: Int) in
                MainActor.assumeIsolated {
                    let viewModel = container.resolve(CharacterInfoViewModel.self, args: characterId)
                    let viewController = CharacterInfoViewController(viewModel: viewModel)
                    
                    return viewController
                }
            }
    }
}
