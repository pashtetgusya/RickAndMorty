import UIKit

// MARK: - UI collection view register cell functions

extension UICollectionView {
    
    /// Регистрирует класс ячейки для последующего использования в коллекции.
    /// - Parameter cell: класс ячейки, который необходимо зарегистрировать.
    func registerCell(_ cell: UICollectionViewCell.Type) {
        register(cell.self, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
    
    /// Регистрирует несколько классов ячеек для последующего использования в коллекции.
    /// - Parameter cells: классы ячейки, которые необходимо зарегистрировать.
    func registerCells(_ cells: UICollectionViewCell.Type...) {
        cells.forEach { registerCell($0) }
    }
}
