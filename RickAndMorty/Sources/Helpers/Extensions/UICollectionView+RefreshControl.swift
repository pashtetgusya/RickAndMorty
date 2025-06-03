import UIKit

// MARK: - UI collection view refresh control functions

extension UICollectionView {
    
    /// Флаг отображения процесса загрузки(обновления) данных в коллекции.
    var isRefreshing: Bool {
        get {
            refreshControl?.isRefreshing ?? false
        }
        set {
            guard let refreshControl else { return }
            
            switch newValue {
            case true where !refreshControl.isRefreshing: refreshControl.beginRefreshing()
            case false where refreshControl.isRefreshing: refreshControl.endRefreshing()
            
            default: break
            }
        }
    }
}
