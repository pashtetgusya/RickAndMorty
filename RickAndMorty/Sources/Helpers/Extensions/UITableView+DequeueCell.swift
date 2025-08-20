import UIKit

// MARK: - UI table view dequeue cell functions

extension UITableView {
    
    /// Выполняет получение повторно используемой ячейки таблицы указанного типа.
    ///
    /// Если ячейка не зарегистрирована или не может быть приведена к указанному типу
    /// выполняет вызов `fatalError` с соответствующим сообщением.
    /// - Parameter indexPath: индекс повторно используемой ячейки таблицы.
    /// - Returns: поврторно используемая ячейка таблицы.
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T
        else { fatalError("cell \(T.self) is not registered in table") }
        
        return cell
    }
}
