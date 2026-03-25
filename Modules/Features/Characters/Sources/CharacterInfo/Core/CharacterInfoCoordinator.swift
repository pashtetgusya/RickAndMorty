import Foundation
import Navigation

// MARK: - Episode list coordinator

/// Интерфейс координатора экрана информации о персонаже из вселенной `"Rick and Morty"`.
protocol CharacterInfoCoordinator: Coordinator {
    
    /// Выполняет отображение экрана информации об эпизоде.
    /// - Parameter episodeId: идентификатор эпизода.
    func presentEpisodeInfoView(for episodeId: Int)
}
