import UIKit

// MARK: - Rick and Morty character filter assembly

/// Класс, отвечающий за регистрацию и сборку зависимостей
/// экрана списка фильтров для персонажей из вселенной `"Rick and Morty"`.
final class RnMCharacterFilterAssembly: DIAssembly {
    
    // MARK: DI assembly protocol implementation
    
    func assemble(container: DIContainer) {
        container
            .register(
                RnMCharacterFilterViewModel.self
            ) { (_, args: (RnMCharacterFilterModel.CharacterFilter, @MainActor (RnMCharacterFilterModel.CharacterFilter) -> Void)) in
                MainActor.assumeIsolated {
                    let currentFilter = args.0
                    let completion = args.1
                    let viewModel = RnMCharacterFilterViewModel(with: currentFilter, completion: completion)
                    
                    return viewModel
                }
            }
        
        container
            .register(
                RnMCharacterFilterViewController.self
            ) { (container, args: (RnMCharacterFilterModel.CharacterFilter, @MainActor (RnMCharacterFilterModel.CharacterFilter) -> Void)) in
                MainActor.assumeIsolated {
                    let viewModel = container.resolve(RnMCharacterFilterViewModel.self, args: args)
                    let viewController = RnMCharacterFilterViewController(viewModel: viewModel)
                    
                    return viewController
                }
            }
    }
}
