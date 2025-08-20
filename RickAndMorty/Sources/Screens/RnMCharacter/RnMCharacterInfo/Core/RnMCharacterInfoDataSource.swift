import UIKit

// MARK: - Rick and Morty character info data source

/// Источник данных таблицы отображения информации о персонаже из вселенной `"Rick and Morty"`.
final class RnMCharacterInfoDataSource: UITableViewDiffableDataSource<RnMCharacterInfoModel.Section.SType, AnyParameter> {
    
    // MARK: Typealiases
    
    /// Замыкание для создания и настройки ячеек таблицы.
    typealias CellProvider = (UITableView, IndexPath, AnyParameter) -> UITableViewCell?
    
    // MARK: Properties
    
    /// Флаг первого отображения данных в таблице.
    private var isFirstUpdate: Bool = true
    
    /// Обработчик создания ячеек по умолчанию.
    private static let defaultCellProvider: CellProvider = { tableView, indexPath, parameter in
        let cell: ParameterCell = tableView.dequeue(for: indexPath)
        cell.setup(with: parameter)
        
        return cell
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - tableView: таблица отображения информации о персонаже.
    ///   - cellProvider: обработчик создания ячеек
    ///   (по умолчанию `RnMCharacterInfoDataSource.defaultCellProvider`).
    init(
        for tableView: UITableView,
        cellProvider: @escaping CellProvider = RnMCharacterInfoDataSource.defaultCellProvider
    ) {
        super.init(tableView: tableView, cellProvider: cellProvider)
        
        self.defaultRowAnimation = .fade
    }
    
    // MARK: UI table view data source functions
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch sectionIdentifier(for: section) {
        case .details: "Details"
        case .episodes: "Episodes"
        
        default: nil
        }
    }
}

// MARK: - Data source update functions

extension RnMCharacterInfoDataSource {
    
    /// Выполняет обновление данных в таблице.
    /// - Parameters:
    ///   - sections: новый список секций для отображения.
    ///   - animated: флаг анимированного обновления (по умолчанию `true`).
    func update(
        with sections: [RnMCharacterInfoModel.Section],
        animated: Bool = true
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<RnMCharacterInfoModel.Section.SType, AnyParameter>()
        sections.forEach {
            snapshot.appendSections([$0.type])
            snapshot.appendItems($0.rows, toSection: $0.type)
        }
        
        apply(snapshot, animatingDifferences: animated && !isFirstUpdate)
        if !isFirstUpdate { isFirstUpdate = false }
    }
}
