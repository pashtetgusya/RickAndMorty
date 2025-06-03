import Foundation

// MARK: - Rick and Morty character list coordinator

/// Интерфейс координатора списка персонажей из вселенной `"Rick and Morty"`.
@MainActor protocol RnMCharacterListCoordinator: AnyObject {
    
    // MARK: Functions
    
    /// Отображает экран списка фильтров для персонажей.
    /// - Parameters:
    ///   - currentFilter: текущие параметры фильтрации для персонажей.
    ///   - completion: замыкание, возвращающее новые параметры фильтрации для персонажей.
    func presentCharacterFilterView(
        with currentFilter: RnMCharacterFilterModel.CharacterFilter,
        completion: @escaping (RnMCharacterFilterModel.CharacterFilter) -> Void
    )
    /// Отображает экран информации о персонаже.
    /// - Parameter characterId: идентификатор персонажа.
    /// - Parameter characterName: имя персонажа.
    func presentCharacterInfoView(for characterId: Int, characterName: String)
}
