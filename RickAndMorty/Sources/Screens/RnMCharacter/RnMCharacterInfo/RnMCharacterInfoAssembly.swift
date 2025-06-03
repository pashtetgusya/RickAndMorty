import UIKit

// MARK: - Rick and Morty character info assembly

/// Класс, отвечающий за создание вью контроллер
/// информации о персонаже из вселенной `"Rick and Morty"`.
@MainActor final class RnMCharacterInfoAssembly {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    private init() { }
    
    // MARK: Build function
    
    /// Создает вью контроллер информации о персонаже из вселенной `"Rick and Morty"`.
    /// - Parameters:
    ///   - characterId: идентификатор персонажа.
    ///   - characterName: имя персонажа.
    ///   - diContainer: контейнер с зависимостями.
    ///   - coordinator: координатор для навигации.
    /// - Returns: вью контроллер.
    static func build(
        characterId: Int,
        characterName: String,
        di diContainer: AppDIContainer,
        coordinator: RnMCharacterListCoordinator
    ) -> UIViewController {
        let diContainer = RnMCharacterInfoDIContainer(di: diContainer)
        let viewModel = RnMCharacterInfoViewModel(
            characterId: characterId,
            characterName: characterName,
            di: diContainer
        )
        let viewController = RnMCharacterInfoViewController(viewModel: viewModel)
        
        return viewController
    }
}
