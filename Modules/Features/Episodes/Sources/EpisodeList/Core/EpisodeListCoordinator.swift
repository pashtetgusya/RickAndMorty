import Foundation
import Navigation

// MARK: - Episode list coordinator

/// Интерфейс координатора экрана списка эпизодов из вселенной `"Rick and Morty"`.
protocol EpisodeListCoordinator: Coordinator {
    
    // MARK: Functions
    
    /// Выполняет отображение экрана информации об эпизоде.
    /// - Parameter episodeId: идентификатор эпизода.
    func presentEpisodeInfoView(for episodeId: Int)
}
