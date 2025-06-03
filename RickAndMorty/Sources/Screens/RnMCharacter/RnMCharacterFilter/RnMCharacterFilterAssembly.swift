import UIKit

// MARK: - Rick and Morty character filter assembly

/// Класс, отвечающий за создание вью контроллер
/// списка фильтров для персонажей из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterFilterAssembly {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    private init() { }
    
    // MARK: Build function
    
    /// Создает вью контроллер списка фильтров для персонажей из вселенной `"Rick and Morty"`.
    /// - Parameters:
    ///   - currentFilter: текущие параметры фильтрации для персонажей.
    ///   - completion: замыкание, возвращающее новые параметры фильтрации для персонажей.
    /// - Returns: вью контроллер.
    static func build(
        with currentFilter: RnMCharacterFilterModel.CharacterFilter,
        completion: @escaping (RnMCharacterFilterModel.CharacterFilter) -> Void
    ) -> UIViewController {
        let viewModel = RnMCharacterFilterViewModel(with: currentFilter, completion: completion)
        let viewController = RnMCharacterFilterViewController(viewModel: viewModel)
        
        return viewController
    }
}
