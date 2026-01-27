import UIKit
import DependencyInjection

// MARK: - Character filter assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// экрана списка фильтров для персонажей из вселенной `"Rick and Morty"`.
final class CharacterFilterAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(in container: DIContainer) {
        container
            .register(
                CharacterFilterViewModel.self
            ) { (_, args: (CharacterFilterTableViewModel.CharacterFilter,
                           @Sendable (CharacterFilterTableViewModel.CharacterFilter) -> Void)) in
                MainActor.assumeIsolated {
                    let currentFilter = args.0
                    let completion = args.1
                    let viewModel = CharacterFilterViewModel(with: currentFilter, completion: completion)
                    
                    return viewModel
                }
            }
        
        container
            .register(
                CharacterFilterViewController.self
            ) { (container, args: (CharacterFilterTableViewModel.CharacterFilter,
                                  @Sendable (CharacterFilterTableViewModel.CharacterFilter) -> Void)) in
                MainActor.assumeIsolated {
                    let viewModel = container.resolve(CharacterFilterViewModel.self, args: args)
                    let viewController = CharacterFilterViewController(viewModel: viewModel)
                    
                    return viewController
                }
            }
    }
}
