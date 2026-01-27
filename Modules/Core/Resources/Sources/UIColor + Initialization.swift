import UIKit

// MARK: - UIColor initialization

extension UIColor {
    
    convenience init?(named: String) {
        self.init(named: named, in: .module, compatibleWith: nil)
    }
}
