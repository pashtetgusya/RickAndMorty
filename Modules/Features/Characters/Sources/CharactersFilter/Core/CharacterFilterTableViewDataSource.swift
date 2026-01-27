import UIKit
import UIComponents

// MARK: - Character filter table view data source

/// Источник данных таблицы отображения списка фильтров для персонажей из вселенной `"Rick and Morty"`.
final class CharacterFilterTableViewDataSource: UITableViewDiffableDataSource<
                                                    CharacterFilterTableViewModel.Section.`Type`,
                                                    CharacterFilterTableViewModel.Section.Row
                                                > {
    
    // MARK: Typealiases
    
    /// Замыкание для создания и настройки ячеек таблицы.
    typealias CellProvider = (UITableView, IndexPath, CharacterFilterTableViewModel.Section.Row) -> UITableViewCell?
    typealias Snapshot = NSDiffableDataSourceSnapshot<CharacterFilterTableViewModel.Section.`Type`,
                                                      CharacterFilterTableViewModel.Section.Row>
                                                    
    // MARK: Properties
    
    /// Обработчик создания ячеек по умолчанию.
    private static let defaultCellProvider: CellProvider = { tableView, indexPath, filter in
        let cell: FilterTalbieViewCell = tableView.dequeue(for: indexPath)
        cell.setup(with: filter)
        
        return cell
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - tableView: таблица отображения списка фильтров для персонажей.
    ///   - cellProvider: обработчик создания ячеек
    ///   (по умолчанию `CharacterFilterTableViewDataSource.defaultCellProvider`).
    init(
        for tableView: UITableView,
        cellProvider: @escaping CellProvider = CharacterFilterTableViewDataSource.defaultCellProvider
    ) {
        super.init(tableView: tableView, cellProvider: cellProvider)
    }
    
    // MARK: UI table view data source functions
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        switch sectionIdentifier(for: section) {
        case .gender: "Gender"
        case .status: "Status"
        
        default: nil
        }
    }
}

// MARK: - Data source update functions

extension CharacterFilterTableViewDataSource {
    
    /// Выполняет обновление данных в таблице.
    /// - Parameters:
    ///   - sections: новый список секций для отображения.
    ///   - animated: флаг анимированного обновления (по умолчанию `true`).
    func update(
        with sections: [CharacterFilterTableViewModel.Section],
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
