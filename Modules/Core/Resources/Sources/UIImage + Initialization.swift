import UIKit

// MARK: - UIImage initialization

extension UIImage {
    
    convenience init?(named: String) {
        self.init(named: named, in: .module, compatibleWith: nil)
    }
}
