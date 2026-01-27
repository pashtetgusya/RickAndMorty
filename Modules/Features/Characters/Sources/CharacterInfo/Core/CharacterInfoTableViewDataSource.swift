import UIKit
import UIComponents

// MARK: - Character info table view data source

/// Класс, реализующий источник данных таблицы отображения
/// информации о персонаже из вселенной `"Rick and Morty"`.
final class CharacterInfoTableViewDataSource: UITableViewDiffableDataSource<
                                         CharacterInfoTableViewModel.Section.`Type`,
                                         CharacterInfoTableViewModel.Section.Row
                                     > {
    
    // MARK: Typealiases
    
    /// Замыкание для создания и настройки ячеек таблицы.
    typealias CellProvider = (UITableView, IndexPath, CharacterInfoTableViewModel.Section.Row) -> UITableViewCell?
    typealias Snapshot = NSDiffableDataSourceSnapshot<CharacterInfoTableViewModel.Section.`Type`,
                                                      CharacterInfoTableViewModel.Section.Row>
                                         
    // MARK: Properties
    
    /// Флаг первого отображения данных в таблице.
    private var isFirstUpdate: Bool = true
    
    /// Обработчик создания ячеек по умолчанию.
    private static let defaultCellProvider: CellProvider = { tableView, indexPath, parameter in
        let cell: ParameterTableViewCell = tableView.dequeue(for: indexPath)
        cell.setup(with: parameter.erased)
        
        return cell
    }
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    /// - Parameters:
    ///   - tableView: таблица для отображения информации о персонаже.
    ///   - cellProvider: обработчик создания ячеек
    ///                   (по умолчанию `CharacterInfoTableViewDataSource.defaultCellProvider`).
    init(
        for tableView: UITableView,
        cellProvider: @escaping CellProvider = CharacterInfoTableViewDataSource.defaultCellProvider
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

extension CharacterInfoTableViewDataSource {
    
    /// Выполняет обновление данных в таблице.
    /// - Parameters:
    ///   - sections: новый список секций для отображения.
    ///   - animated: флаг анимированного обновления (по умолчанию `true`).
    func update(
        with sections: [CharacterInfoTableViewModel.Section],
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
