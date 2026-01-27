import Foundation
import Navigation

// MARK: - Character list coordinator

/// Интерфейс координатора экрана списка персонажей из вселенной `"Rick and Morty"`.
protocol CharacterListCoordinator: Coordinator {
    
    // MARK: Functions
    
    /// Выполняет отображение экрана списка фильтров для персонажей.
    /// - Parameters:
    ///   - currentFilter: текущие параметры фильтрации для персонажей.
    ///   - completion: замыкание, возвращающее новые параметры фильтрации для персонажей.
    func presentCharacterFilterView(
        with currentFilter: CharacterFilterTableViewModel.CharacterFilter,
        completion: @escaping @Sendable (CharacterFilterTableViewModel.CharacterFilter) -> Void
    )
    /// Выполняет отображение экрана информации о персонаже.
    /// - Parameter characterId: идентификатор персонажа.
    func presentCharacterInfoView(for characterId: Int)
}
