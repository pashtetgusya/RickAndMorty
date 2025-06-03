import UIKit

// MARK: - Base view controller view

/// Класс, реализующий базовое вью для контроллеров.
class BaseViewControllerView: UIView {
    
    // MARK: Initialization
    
    /// Создает новый экземпляр класса.
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View setup functions

private extension BaseViewControllerView {
    
    /// Настраивает вью.
    func setup() {
        backgroundColor = UIColor.viewDefaultBackground
    }
}
