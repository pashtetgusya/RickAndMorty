import UIKit

// MARK: - UI collection view dequeue supplementary functions

public extension UICollectionView {
    
    /// Выполняет получение повторно используемого хедера коллекции указанного типа.
    ///
    /// Если хедер не зарегистрирован или не может быть приведен к указанному типу
    /// выполняется вызов `fatalError` с соответствующим сообщением.
    /// - Parameter indexPath: индекс повторно используемого хедера коллекции.
    /// - Returns: поврторно используемый хедер коллекции.
    func dequeueHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        guard
            let header = dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: T.reuseIdentifier,
                for: indexPath
            ) as? T
        else { fatalError("header \(T.self) is not registered in collection") }
        
        return header
    }
    
    /// Выполняет получение повторно используемого футера коллекции указанного типа.
    ///
    /// Если футер не зарегистрирован или не может быть приведен к указанному типу
    /// выполняется вызов `fatalError` с соответствующим сообщением.
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
