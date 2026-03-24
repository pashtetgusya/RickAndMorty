import Foundation
import Navigation

// MARK: - Episode list coordinator

/// Интерфейс координатора экрана информации об эпизоде из вселенной `"Rick and Morty"`.
protocol EpisodeInfoCoordinator: Coordinator {
    
    /// Выполняет отображение экрана информации о персонаже.
    /// - Parameter characterId: идентификатор персонажа.
    func presentCharacterInfoView(for characterId: Int)
}
