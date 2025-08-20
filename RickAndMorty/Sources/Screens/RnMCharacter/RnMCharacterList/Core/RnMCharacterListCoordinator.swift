import Foundation

// MARK: - Rick and Morty character list coordinator

/// Интерфейс координатора списка персонажей из вселенной `"Rick and Morty"`.
@MainActor protocol RnMCharacterListCoordinator: AnyObject, Sendable {
    
    // MARK: Functions
    
    /// Выполняет отображение экрана списка фильтров для персонажей.
    /// - Parameters:
    ///   - currentFilter: текущие параметры фильтрации для персонажей.
    ///   - completion: замыкание, возвращающее новые параметры фильтрации для персонажей.
    func presentCharacterFilterView(
        with currentFilter: RnMCharacterFilterModel.CharacterFilter,
        completion: @MainActor @escaping (RnMCharacterFilterModel.CharacterFilter) -> Void
    )
    /// Выполняет отображение экрана информации о персонаже.
    /// - Parameter characterId: идентификатор персонажа.
    func presentCharacterInfoView(for characterId: Int)
}
