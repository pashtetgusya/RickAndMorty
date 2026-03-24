import UIKit
import UIComponents

// MARK: - Episode info collection view data source

/// Класс, реализующий источник данных коллекции отображения
/// информации об эпизоде из вселенной `"Rick and Morty"`.
final class EpisodeInfoCollectionViewDataSource: UICollectionViewDiffableDataSource<
                                                     EpisodeInfoCollectionViewModel.Section.`Type`,
                                                     EpisodeInfoCollectionViewModel.Section.Row
                                                 > {
    
    // MARK: Typealiases
    
    /// Замыкание для создания и настройки ячеек таблицы.
    typealias CellProvider = (UICollectionView, IndexPath, EpisodeInfoCollectionViewModel.Section.Row) -> UICollectionViewCell?
    typealias Snapshot = NSDiffableDataSourceSnapshot<EpisodeInfoCollectionViewModel.Section.`Type`,
                                                      EpisodeInfoCollectionViewModel.Section.Row>
    
    // MARK: Properties
    
    /// Обработчик создания ячеек коллекции по умолчанию.
    private static let defaultCellProvider: CellProvider = { collectionView, indexPath, itemIdentifier in
        let cell: ParameterCollectionViewCell = collectionView.dequeue(for: indexPath)
        cell.setup(with: itemIdentifier)
        
        return cell
    }
    /// Обработчик создани хедеров / футеров коллекции по умолчанию.
    private static let defaultSupplementaryViewProvider: SupplementaryViewProvider = { collectionView, elementKind, indexPath in
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            let header: TitleCollectionHeaderView = collectionView.dequeueHeader(for: indexPath)
            if let sectionType: EpisodeInfoCollectionViewModel.Section.`Type` = .init(rawValue: indexPath.section) {
                header.setup(with: sectionType.description)
            }
            
            return header
        
        default: return nil
        }
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - collectionView: коллекция для отображения информации об эпизоде.
    ///   - cellProvider: обработчик создания ячеек (по умолчанию используется `EpisodeInfoCollectionViewDataSource.defaultCellProvider`).
    ///   - supplementaryViewProvider: обработчик создания хедеров / футеров коллекции (по умолчанию используется `EpisodeInfoCollectionViewDataSource.defaultSupplementaryViewProvider`).
    init(
        for collectionView: UICollectionView,
        cellProvider: @escaping CellProvider = EpisodeInfoCollectionViewDataSource.defaultCellProvider,
        supplementaryViewProvider: @escaping SupplementaryViewProvider = EpisodeInfoCollectionViewDataSource.defaultSupplementaryViewProvider
    ) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        
        self.supplementaryViewProvider = supplementaryViewProvider
    }
}

// MARK: - Data source update functions

extension EpisodeInfoCollectionViewDataSource {
    
    /// Выполняет обновление данных в таблице.
    /// - Parameters:
    ///   - sections: новый список секций для отображения.
    ///   - animated: флаг анимированного обновления (по умолчанию `true`).
    func update(
        with sections: [EpisodeInfoCollectionViewModel.Section],
        animated: Bool = true
    ) {
        var snapshot = Snapshot()
        sections.forEach {
            snapshot.appendSections([$0.type])
            snapshot.appendItems($0.rows, toSection: $0.type)
        }
        
        apply(snapshot, animatingDifferences: animated)
    }
}
