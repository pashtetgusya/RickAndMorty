import UIKit

// MARK: - Rick and Morty character list data source

/// Источник данных коллекции отображения списка персонажей из вселенной `"Rick and Morty"`.
final class RnMCharacterListDataSource: UICollectionViewDiffableDataSource<Int, RnMCharacterListModel.Character> {
    
    // MARK: Typealiases
    
    /// Замыкание для создания и настройки ячеек коллекции.
    typealias CellProvider = (UICollectionView, IndexPath, RnMCharacterListModel.Character) -> UICollectionViewCell?
    /// Замыкание для создания и настройки хедеров / футеров коллекции.
    typealias SupplementaryViewProvider = UICollectionViewDiffableDataSource<Int, String>.SupplementaryViewProvider
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, RnMCharacterListModel.Character>
    
    // MARK: Properties
    
    /// Флаг первого отображения данных в коллекции.
    private var isFirstUpdate: Bool = true 
    
    /// Обработчик создания ячеек коллекции по умолчанию.
    private static let defaultCellProvider: CellProvider = { collectionView, indexPath, character in
        let viewModel = RnMCharacterCellViewModel(character: character, imageProvider: nil)
        let cell: RnMCharacterCell = collectionView.dequeue(for: indexPath)
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
    ///   (по умолчанию используется `RnMCharacterListDataSource.defaultCellProvider`).
    ///   - supplementaryViewProvider: обработчик создания хедеров / футеров коллекции
    ///   (по умолчанию используется `RnMCharacterListDataSource.defaultSupplementaryViewProvider`).
    init(
        for collectionView: UICollectionView,
        cellProvider: @escaping CellProvider = RnMCharacterListDataSource.defaultCellProvider,
        supplementaryViewProvider: @escaping SupplementaryViewProvider = RnMCharacterListDataSource.defaultSupplementaryViewProvider
    ) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        
        self.supplementaryViewProvider = supplementaryViewProvider
    }
}

// MARK: - Data source update functions

extension RnMCharacterListDataSource {
    
    /// Выполняет обновление данных в коллекции.
    /// - Parameters:
    ///   - characters: новый список персонажей для отображения.
    ///   - animated: флаг анимированного обновления (по умолчанию `true`).
    func update(
        with characters: [RnMCharacterListModel.Character],
        animated: Bool = true
    ) {
        var snapshot = Snapshot()
        if !characters.isEmpty {
            snapshot.appendSections([0])
            snapshot.appendItems(characters)
        }
        
        apply(snapshot, animatingDifferences: animated && !isFirstUpdate)
        if !isFirstUpdate { isFirstUpdate = false }
    }
}
