import UIKit

// MARK: - UI collection view register supplementary functions

public extension UICollectionView {
    
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
