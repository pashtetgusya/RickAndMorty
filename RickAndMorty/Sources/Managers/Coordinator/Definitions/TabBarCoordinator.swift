import UIKit

// MARK: - Tab bar coordinator protocol

/// Интерфейс координатора `UITabBarController'а`.
protocol TabBarCoordinator: Coordinator {
    
    // MARK: Properties
    
    /// Координатор для вкладки с персонажами.
    var charactersCoordinator: Coordinator? { get }
    /// Координатор для вкладки с локациями.
    var locationsCoordinator: Coordinator? { get }
    /// Координатор для вкладки с эпизодами.
    var episodesCoordinator: Coordinator? { get }
}
