import UIKit

// MARK: - Episode info collection view layut

/// Лейаут коллекции отображения информации об эпизоде из вселенной `"Rick and Morty"`.
final class EpisodeInfoCollectionViewLayout: UICollectionViewCompositionalLayout {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        super.init { _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.separatorConfiguration = .init(listAppearance: .insetGrouped)
            configuration.showsSeparators = true
            configuration.headerMode = .supplementary
            
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
