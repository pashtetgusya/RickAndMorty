import UIKit

// MARK: - UI collection view dequeue cell functions

extension UICollectionView {
    
    /// Получает и возвращает повторно используемую ячейку коллекции указанного типа.
    ///
    /// Если ячейка не зарегистрирована или не может быть приведена к указанному типу
    /// вызовется `fatalError` с соответствующим сообщением.
    /// - Parameter indexPath: индекс повторно используемой ячейки коллекции.
    /// - Returns: поврторно используемая ячейка коллекции.
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
        else { fatalError("cell \(T.self) is not registered in collection") }
        
        return cell
    }
}
