import UIKit

// MARK: - Episode list collection view layout

/// Лейаут коллекции отображения списка эпизодов из вселенной `"Rick and Morty"`.
final class EpisodeListCollectionViewLayout: UICollectionViewCompositionalLayout {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameter collectionView: коллекция для котороей создается лейаут
    init(collectionView: UICollectionView?) {
        super.init { [weak collectionView] indexPath, layoutEnvironment in
            let numberOfSections = collectionView?.numberOfSections ?? 1
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.separatorConfiguration = .init(listAppearance: .grouped)
            configuration.showsSeparators = true
            configuration.headerMode = .supplementary
            configuration.footerMode = numberOfSections - 1 == indexPath ? .supplementary : .none
            
            let sectionLayout = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: layoutEnvironment
            )
            
            return sectionLayout
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { nil }
}
