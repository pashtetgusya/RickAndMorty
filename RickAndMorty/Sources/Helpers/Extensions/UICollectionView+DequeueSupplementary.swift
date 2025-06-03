import UIKit

// MARK: - UI collection view dequeue supplementary functions

extension UICollectionView {
    
    /// Получает и возвращает повторно используемый футер коллекции указанного типа.
    ///
    /// Если футер не зарегистрирован или не может быть приведен к указанному типу
    /// вызовется `fatalError` с соответствующим сообщением.
    /// - Parameter indexPath: индекс повторно используемого футера коллекции.
    /// - Returns: поврторно используемый футер коллекции.
    func dequeueFooter<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard
            let footer = dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: T.reuseIdentifier,
                for: indexPath
            ) as? T
        else { fatalError("footer \(T.self) is not registered in collection") }
        
        return footer
    }
}
