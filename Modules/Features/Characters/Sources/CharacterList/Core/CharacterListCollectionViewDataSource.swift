import UIKit
import UIComponents

// MARK: - Character list collection view data source

/// Источник данных коллекции отображения списка персонажей из вселенной `"Rick and Morty"`.
final class CharacterListCollectionViewDataSource: UICollectionViewDiffableDataSource<
                                                       CharacterListCollectionViewModel.Section.`Type`,
                                                       CharacterListCollectionViewModel.Section.Row
                                                   > {
    
    // MARK: Typealiases
    
    /// Замыкание для создания и настройки ячеек коллекции.
    typealias CellProvider = (UICollectionView, IndexPath, CharacterListCollectionViewModel.Section.Row) -> UICollectionViewCell?
    /// Замыкание для создания и настройки хедеров / футеров коллекции.
    typealias SupplementaryViewProvider = UICollectionViewDiffableDataSource<Int, String>.SupplementaryViewProvider
    typealias Snapshot = NSDiffableDataSourceSnapshot<CharacterListCollectionViewModel.Section.`Type`,
                                                      CharacterListCollectionViewModel.Section.Row>
    
    // MARK: Properties
    
    /// Флаг первого отображения данных в коллекции.
    private var isFirstUpdate: Bool = true 
    
    /// Обработчик создания ячеек коллекции по умолчанию.
    private static let defaultCellProvider: CellProvider = { collectionView, indexPath, character in
        let viewModel = CharacterListCollectionViewCellViewModel(character: character, imageRepository: nil)
        let cell: CharacterListCollectionViewCell = collectionView.dequeue(for: indexPath)
        cell.setup(with: viewModel)
        
        return cell
    }
    /// Обработчик создани хедеров / футеров коллекции по умолчанию.
    private static let defaultSupplementaryViewProvider: SupplementaryViewProvider = { collectionView, elementKind, indexPath in
        switch elementKind {
        case UICollectionView.elementKindSectionFooter:
            let footerView: SpinerCollectionFooterView = collectionView.dequeueFooter(for: indexPath)
            
            return footerView
        
        default: fatalError("collection supplementaryElement of \(elementKind) is not registered in collection")
        }
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - collectionView: коллекция отображения списка персонажей.
    ///   - cellProvider: обработчик создания ячеек коллекции
    ///                   (по умолчанию используется `CharacterListCollectionViewDataSource.defaultCellProvider`).
    ///   - supplementaryViewProvider: обработчик создания хедеров / футеров коллекции
    ///                   (по умолчанию используется `CharacterListCollectionViewDataSource.defaultSupplementaryViewProvider`).
    init(
        for collectionView: UICollectionView,
        cellProvider: @escaping CellProvider = CharacterListCollectionViewDataSource.defaultCellProvider,
        supplementaryViewProvider: @escaping SupplementaryViewProvider = CharacterListCollectionViewDataSource.defaultSupplementaryViewProvider
    ) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        
        self.supplementaryViewProvider = supplementaryViewProvider
    }
}

// MARK: - Data source update functions

extension CharacterListCollectionViewDataSource {
    
    /// Выполняет обновление данных в коллекции.
    /// - Parameters:
    ///   - sections: новый список секций для отображения.
    ///   - animated: флаг анимированного обновления (по умолчанию `true`).
    func update(
        with sections: [CharacterListCollectionViewModel.Section],
        animated: Bool = true
    ) {
        var snapshot = Snapshot()
        
        sections.forEach {
            snapshot.appendSections([$0.type])
            snapshot.appendItems($0.rows, toSection: $0.type)
        }
        
        apply(snapshot, animatingDifferences: animated && !isFirstUpdate)
        if !isFirstUpdate { isFirstUpdate = false }
    }
}
