import UIKit

// MARK: - UI table view register cell functions

public extension UITableView {
    
    /// Выполняет регистрацию класса ячейки для последующего использования в таблице.
    /// - Parameter cell: класс ячейки, который необходимо зарегистрировать.
    func registerCell(_ cell: UITableViewCell.Type) {
        register(cell.self, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    
    /// Выполняет регистрацию нескольких классов ячеек для последующего использования в таблице.
    /// - Parameter cells: классы ячейки, которые необходимо зарегистрировать.
    func registerCells(_ cells: UITableViewCell.Type...) {
        cells.forEach { registerCell($0) }
    }
}
