import UIKit

// MARK: - Rick and Morty character list collection data source

/// Источник данных коллекции отображения списка персонажей из вселенной `"Rick and Morty"`.
final class RnMCharacterListCollectionDataSource: UICollectionViewDiffableDataSource<Int, RnMCharacterListModel.Character> {
    
    // MARK: Typealiases
    
    /// Замыкание для создания и настройки ячеек коллекции.
    typealias CellProvider = (UICollectionView, IndexPath, RnMCharacterListModel.Character) -> UICollectionViewCell?
    /// Замыкание для создания и настройки хедеров / футеров коллекции.
    typealias SupplementaryViewProvider = UICollectionViewDiffableDataSource<Int, String>.SupplementaryViewProvider
    
    // MARK: Properties
    
    /// Флаг первого отображения данных в коллекции.
    private var isFirstUpdate: Bool = true 
    
    /// Обработчик создания ячеек по умолчанию.
    private static let defaultCellProvider: CellProvider = { collectionView, indexPath, character in
        let cell: RnMCharacterCell = collectionView.dequeue(for: indexPath)
        
        return cell
    }
    /// Обработчик создани хедеров / футеров по умолчанию.
    private static let defaultSupplementaryViewProvider: SupplementaryViewProvider = { collectionView, kind, indexPath in
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView: SpinerCollectionFooterView = collectionView.dequeueFooter(for: indexPath)
            
            return footerView
        
        default: fatalError("collection supplementaryElement of \(kind) is not registered in collection")
        }
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - collectionView: коллекция отображения списка персонажей.
    ///   - cellProvider: обработчик создания ячеек
    ///   (по умолчанию `RnMCharacterListDataSource.defaultCellProvider`).
    ///   - supplementaryViewProvider: обработчик создания хедеров / футеров
    ///   (по умолчанию `RnMCharacterListCollectionDataSource.defaultSupplementaryViewProvider`).
    init(
        for collectionView: UICollectionView,
        cellProvider: @escaping CellProvider = RnMCharacterListCollectionDataSource.defaultCellProvider,
        supplementaryViewProvider: @escaping SupplementaryViewProvider = RnMCharacterListCollectionDataSource.defaultSupplementaryViewProvider
    ) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        
        self.supplementaryViewProvider = supplementaryViewProvider
    }
}

// MARK: - Data source update functions

extension RnMCharacterListCollectionDataSource {
    
    /// Выполняет обновление данных в коллекции.
    /// - Parameters:
    ///   - characters: новый список персонажей для отображения.
    ///   - animated: флаг анимированного обновления (по умолчанию `true`).
    func update(
        with characters: [RnMCharacterListModel.Character],
        animated: Bool = true
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RnMCharacterListModel.Character>()
        if !characters.isEmpty {
            snapshot.appendSections([0])
            snapshot.appendItems(characters)
        }
        
        apply(snapshot, animatingDifferences: animated && !isFirstUpdate)
        if !isFirstUpdate { isFirstUpdate = false }
    }
}
