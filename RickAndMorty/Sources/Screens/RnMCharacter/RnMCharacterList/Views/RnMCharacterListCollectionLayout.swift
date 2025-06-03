import UIKit

// MARK: - Rick and Morty character list collection layout

/// Лейаут коллекции отображения списка персонажей из вселенной `"Rick and Morty"`.
final class RnMCharacterListCollectionLayout: UICollectionViewCompositionalLayout {
    
    // MARK: Constants
    
    /// Перечень констант, использующихся при конфигурации лейаута коллекции.
    private enum Constants {
        
        /// Количество колонок.
        static let countItemColumns: CGFloat = 2
        /// Соотношение сторон ячейки (ширина / высота).
        static let itemRatio: CGFloat = 5 / 4
        
        /// Расстояние между элементами в группе.
        static let interItemSpacing: CGFloat = 20
        
        /// Расстояние между группами (секциями).
        static let interGroupSpacing: CGFloat = 10
        /// Отступы группы.
        static let groupInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 30, bottom: 10, trailing: 30
        )
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    init() {
        super.init { _, _ in
            let spinerFooterSupplementaryItemLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(1)
            )
            let spinerFooterSupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: spinerFooterSupplementaryItemLayoutSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            
            let itemLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1 / Constants.countItemColumns),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemLayoutSize)
            
            let groupLayoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1 / Constants.countItemColumns * Constants.itemRatio)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupLayoutSize,
                repeatingSubitem: item,
                count: Int(Constants.countItemColumns)
            )
            group.contentInsets = Constants.groupInsets
            group.interItemSpacing = .fixed(Constants.interItemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [spinerFooterSupplementaryItem]
            section.interGroupSpacing = Constants.interGroupSpacing
            
            return section
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
