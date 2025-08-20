import UIKit

// MARK: - UI table view dequeue header / footer functions

extension UITableView {
    
    /// Выполняет получение повторно используемого хедера таблицы указанного типа.
    ///
    /// Если хедер не зарегистрирован или не может быть приведен к указанному типу
    /// выполняет вызов `fatalError` с соответствующим сообщением.
    /// - Returns: поврторно используемый хедер таблицы.
    func dequeueHeader<T: UITableViewHeaderFooterView>() -> T {
        guard
            let header = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T
        else { fatalError("header \(T.self) is not registered in table") }
        
        return header
    }
}
