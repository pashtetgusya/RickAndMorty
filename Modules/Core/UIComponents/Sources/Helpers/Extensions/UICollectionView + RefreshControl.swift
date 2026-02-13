import UIKit

// MARK: - UI collection view refresh control functions

public extension UICollectionView {
    
    /// Флаг отображения процесса загрузки (обновления) данных в коллекции.
    var isRefreshing: Bool {
        get {
            refreshControl?.isRefreshing ?? false
        }
        set {
            guard let refreshControl else { return }
            
            switch newValue {
            case true where !refreshControl.isRefreshing:
                refreshControl.beginRefreshing()
                
                let newY = contentOffset.y + -refreshControl.frame.size.height
                let newOffset = CGPoint(x: 0, y: newY)
                setContentOffset(newOffset, animated: true)
            case false where refreshControl.isRefreshing: refreshControl.endRefreshing()
            
            default: break
            }
        }
    }
}
