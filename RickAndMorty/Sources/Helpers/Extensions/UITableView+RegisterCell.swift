import UIKit

// MARK: - UI table view register cell functions

extension UITableView {
    
    /// Регистрирует класс ячейки для последующего использования в таблице.
    /// - Parameter cell: класс ячейки, который необходимо зарегистрировать.
    func registerCell(_ cell: UITableViewCell.Type) {
        register(cell.self, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    /// Регистрирует несколько классов ячеек для последующего использования в таблице.
    /// - Parameter cells: классы ячейки, которые необходимо зарегистрировать.
    func registerCells(_ cells: UITableViewCell.Type...) {
        cells.forEach { registerCell($0) }
    }
}
