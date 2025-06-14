import UIKit

// MARK: - UI table view register header / footer functions

extension UITableView {
    
    /// Регистрирует класс хедера для последующего использования в таблице.
    /// - Parameter header: класс хедера, который необходимо зарегистрировать.
    func registerHeader(_ header: UITableViewHeaderFooterView.Type) {
        register(header.self, forHeaderFooterViewReuseIdentifier: header.reuseIdentifier)
    }
}
