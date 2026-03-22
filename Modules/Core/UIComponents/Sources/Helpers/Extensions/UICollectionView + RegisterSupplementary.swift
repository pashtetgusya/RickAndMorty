import UIKit

// MARK: - UI collection view register supplementary functions

public extension UICollectionView {
    
    /// Выполняет регистрацию хедера для последующего использования в коллекции.
    /// - Parameter header: класс хедера, который необходимо зарегистрировать.
    func registerHeader(_ header: UICollectionReusableView.Type) {
        register(
            header.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: header.reuseIdentifier
        )
    }
    
    /// Выполняет регистрацию футера для последующего использования в коллекции.
    /// - Parameter footer: класс футера, который необходимо зарегистрировать.
    func registerFooter(_ footer: UICollectionReusableView.Type) {
        register(
            footer.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: footer.reuseIdentifier
        )
    }
}
