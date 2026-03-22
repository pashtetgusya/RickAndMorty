import UIKit
import UIComponents

// MARK: - Episode list collection view data source

/// Источник данных коллекции отображения списка эпизодов из вселенной `"Rick and Morty"`.
final class EpisodeListCollectionViewDataSource: UICollectionViewDiffableDataSource<
                                                     EpisodeListCollectionViewModel.Section.`Type`,
                                                     EpisodeListCollectionViewModel.Section.Row
                                                 > {
    
    // MARK: Typealiases
    
    /// Замыкание для создания и настройки ячеек коллекции.
    typealias CellProvider = (UICollectionView, IndexPath, EpisodeListCollectionViewModel.Section.Row) -> UICollectionViewCell?
    typealias Snapshot = NSDiffableDataSourceSnapshot<EpisodeListCollectionViewModel.Section.`Type`,
                                                      EpisodeListCollectionViewModel.Section.Row>
    
    // MARK: Properties
    
    /// Обработчик создания ячеек коллекции по умолчанию.
    private static let defaultCellProvider: CellProvider = { collectionView, indexPath, episode in
        let cell: EpisodeListCollectionViewCell = collectionView.dequeue(for: indexPath)
        cell.setup(with: episode)
        
        return cell
    }
    /// Обработчик создани хедеров / футеров коллекции по умолчанию.
    private static let defaultSupplementaryViewProvider: SupplementaryViewProvider = { collectionView, elementKind, indexPath in
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return collectionView.dequeueHeader(for: indexPath) as TitleCollectionHeaderView
        case UICollectionView.elementKindSectionFooter:
            return collectionView.dequeueFooter(for: indexPath) as SpinerCollectionFooterView
        
        default: return nil
        }
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - collectionView: коллекция отображения списка эпизодов.
    ///   - cellProvider: обработчик создания ячеек коллекции
    ///                   (по умолчанию используется `EpisodeListCollectionViewDataSource.defaultCellProvider`).
    ///   - supplementaryViewProvider: обработчик создания хедеров / футеров коллекции
    ///                                (по умолчанию используется `EpisodeListCollectionViewDataSource.defaultSupplementaryViewProvider`).
    init(
        for collectionView: UICollectionView,
        cellProvider: @escaping CellProvider = EpisodeListCollectionViewDataSource.defaultCellProvider,
        supplementaryViewProvider: @escaping SupplementaryViewProvider = EpisodeListCollectionViewDataSource.defaultSupplementaryViewProvider
    ) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        
        self.supplementaryViewProvider = supplementaryViewProvider
    }
}

// MARK: - Data source update functions

extension EpisodeListCollectionViewDataSource {
    
    /// Выполняет обновление данных в коллекции.
    /// - Parameters:
    ///   - sections: новый список секций для отображения.
    ///   - animated: флаг анимированного обновления (по умолчанию `true`).
    func update(
        with sections: [EpisodeListCollectionViewModel.Section],
        animated: Bool = true
    ) {
        var snapshot = Snapshot()
        sections.enumerated().forEach { index, section in
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.rows, toSection: section.type)
        }
        
        apply(snapshot)
    }
}
